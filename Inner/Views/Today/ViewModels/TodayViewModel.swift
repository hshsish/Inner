//
//  TodayViewModel.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class TodayViewModel {
    private let dateProvider: AppDateProvider
    private let healthRepository: HealthRepository
    private let checkInRepository: CheckInRepository
    private let baselineRepository: BaselineRepository
    private let buildDailyState: BuildDailyStateUseCase

    var date = Date()
    var state: DailyState?
    var baselines: [HealthMetric: BaselineSnapshot] = [:]
    var isLoading = false
    var errorMessage: String?

    init(
        dateProvider: AppDateProvider,
        healthRepository: HealthRepository,
        checkInRepository: CheckInRepository,
        baselineRepository: BaselineRepository
    ) {
        self.dateProvider = dateProvider
        self.healthRepository = healthRepository
        self.checkInRepository = checkInRepository
        self.baselineRepository = baselineRepository

        buildDailyState = BuildDailyStateUseCase(
            healthRepository: healthRepository,
            checkInRepository: checkInRepository,
            baselineRepository: baselineRepository
        )
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let today = dateProvider.startOfDay(
                for: Date()
            )

            date = today

            let fetchedBaselines = try await baselineRepository.fetchAll()

            baselines = Dictionary(
                uniqueKeysWithValues: fetchedBaselines.map {
                    ($0.metric, $0)
                }
            )

            state = try await buildDailyState.execute(
                for: today
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        await load()
    }
}
