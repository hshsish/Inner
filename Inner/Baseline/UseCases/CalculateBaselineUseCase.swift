//
//  CalculateBaselineUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

struct CalculateBaselineUseCase: Sendable {
    private let healthRepository: HealthRepository
    private let calculator: BaselineCalculator

    init(
        healthRepository: HealthRepository,
        calculator: BaselineCalculator = BaselineCalculator()
    ) {
        self.healthRepository = healthRepository
        self.calculator = calculator
    }

    func execute(
        metric: HealthMetric,
        range: DateRange
    ) async throws -> BaselineSnapshot? {
        let snapshots = try await healthRepository.fetch(
            in: range
        )

        let values = snapshots.compactMap {
            metricValue(
                for: metric,
                snapshot: $0
            )
        }

        return calculator.calculate(
            metric: metric,
            values: values
        )
    }

    private func metricValue(
        for metric: HealthMetric,
        snapshot: HealthSnapshot
    ) -> (date: Date, value: Double)? {
        let value: Double?

        switch metric {
        case .heartRate:
            value = snapshot.heartRate

        case .restingHeartRate:
            value = snapshot.restingHeartRate

        case .hrv:
            value = snapshot.hrv

        case .respiratoryRate:
            value = snapshot.respiratoryRate

        case .sleep:
            value = snapshot.sleep.map {
                $0.duration / 3600
            }

        case .steps:
            value = snapshot.steps.map(Double.init)

        case .activeEnergy:
            value = snapshot.activeEnergy

        case .weight:
            value = snapshot.weight
        }

        guard let value else {
            return nil
        }

        return (
            date: snapshot.date,
            value: value
        )
    }
}
