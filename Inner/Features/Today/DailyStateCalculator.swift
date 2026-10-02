//
//  DailyStateCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//
import Foundation

struct DailyStateCalculator: Sendable {
    private let deviationCalculator: MetricDeviationCalculator

    init(
        deviationCalculator: MetricDeviationCalculator = MetricDeviationCalculator()
    ) {
        self.deviationCalculator = deviationCalculator
    }

    func calculate(
        date: Date,
        health: HealthSnapshot?,
        checkIn: DailyCheckIn?,
        baselines: [HealthMetric: BaselineSnapshot]
    ) -> DailyState {
        var deviations: [MetricDeviation] = []

        if let health {
            appendDeviation(
                metric: .heartRate,
                value: health.heartRate,
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .restingHeartRate,
                value: health.restingHeartRate,
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .hrv,
                value: health.hrv,
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .respiratoryRate,
                value: health.respiratoryRate,
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .sleep,
                value: health.sleep.map {
                    $0.duration / 3600
                },
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .steps,
                value: health.steps.map(Double.init),
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .activeEnergy,
                value: health.activeEnergy,
                baselines: baselines,
                to: &deviations
            )

            appendDeviation(
                metric: .weight,
                value: health.weight,
                baselines: baselines,
                to: &deviations
            )
        }

        let mood = checkIn.flatMap {
            $0.eveningMood.map { Double($0.rawValue) }
                ?? $0.morningMood.map { Double($0.rawValue) }
        }

        let energy = checkIn.flatMap {
            $0.eveningEnergy.map { Double($0.rawValue) }
                ?? $0.morningEnergy.map { Double($0.rawValue) }
        }

        let stress = checkIn.flatMap {
            $0.eveningStress.map { Double($0.rawValue) }
                ?? $0.morningStress.map { Double($0.rawValue) }
        }
        let baselineStatus = calculateBaselineStatus(
            baselines: baselines
        )

        return DailyState(
            id: UUID(),
            date: date,
            mood: mood,
            energy: energy,
            stress: stress,
            health: health,
            checkIn: checkIn,
            deviations: deviations,
            baselineStatus: baselineStatus,
            generatedAt: Date(),
            algorithmVersion: AppConfiguration.dailyStateAlgorithmVersion
        )
    }

    private func appendDeviation(
        metric: HealthMetric,
        value: Double?,
        baselines: [HealthMetric: BaselineSnapshot],
        to deviations: inout [MetricDeviation]
    ) {
        guard
            let value,
            let baseline = baselines[metric]
        else {
            return
        }

        deviations.append(
            deviationCalculator.calculate(
                metric: metric,
                currentValue: value,
                baseline: baseline
            )
        )
    }

    private func calculateBaselineStatus(
        baselines: [HealthMetric: BaselineSnapshot]
    ) -> BaselineStatus {
        guard !baselines.isEmpty else {
            return .calibrating
        }

        let statuses = baselines.values.map(\.status)

        if statuses.contains(.calibrating) {
            return .calibrating
        }

        if statuses.contains(.building) {
            return .building
        }

        if statuses.contains(.limited) {
            return .limited
        }

        return .established
    }
}
