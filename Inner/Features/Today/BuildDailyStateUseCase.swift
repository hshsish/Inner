//
//  BuildDailyStateUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct BuildDailyStateUseCase: Sendable {
    private let healthRepository: HealthRepository
    private let checkInRepository: CheckInRepository
    private let baselineRepository: BaselineRepository
    private let calculator: DailyStateCalculator

    init(
        healthRepository: HealthRepository,
        checkInRepository: CheckInRepository,
        baselineRepository: BaselineRepository,
        calculator: DailyStateCalculator = DailyStateCalculator()
    ) {
        self.healthRepository = healthRepository
        self.checkInRepository = checkInRepository
        self.baselineRepository = baselineRepository
        self.calculator = calculator
    }

    func execute(
        for date: Date
    ) async throws -> DailyState {
        let health = try await healthRepository.fetch(
            for: date
        )

        let checkIn = try await checkInRepository.fetch(
            for: date
        )

        let baselineSnapshots = try await baselineRepository.fetchAll()

        let baselines = Dictionary(
            uniqueKeysWithValues: baselineSnapshots.map {
                ($0.metric, $0)
            }
        )

        return calculator.calculate(
            date: date,
            health: health,
            checkIn: checkIn,
            baselines: baselines
        )
    }
}