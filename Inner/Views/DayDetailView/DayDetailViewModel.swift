//
//  DayDetailViewModel.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation
import Observation

@MainActor
@Observable
final class DayDetailViewModel {
private let healthRepository: HealthRepository
private let checkInRepository: CheckInRepository
private let baselineRepository: BaselineRepository
private let dateProvider: AppDateProvider
private let buildDailyState: BuildDailyStateUseCase

let date: Date

var state: DailyState?
var baselines: [HealthMetric: BaselineSnapshot] = [:]
var isLoading = false
var errorMessage: String?

init(
    date: Date,
    healthRepository: HealthRepository,
    checkInRepository: CheckInRepository,
    baselineRepository: BaselineRepository,
    dateProvider: AppDateProvider
) {
    self.date = date
    self.healthRepository = healthRepository
    self.checkInRepository = checkInRepository
    self.baselineRepository = baselineRepository
    self.dateProvider = dateProvider

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
        let day = dateProvider.startOfDay(for: date)

        let fetchedBaselines =
            try await baselineRepository.fetchAll()

        baselines = Dictionary(
            uniqueKeysWithValues:
                fetchedBaselines.map {
                    ($0.metric, $0)
                }
        )

        state = try await buildDailyState.execute(
            for: day
        )
    } catch {
        errorMessage = error.localizedDescription
    }

    isLoading = false
}

}
