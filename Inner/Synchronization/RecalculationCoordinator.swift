//
//  RecalculationCoordinator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import Foundation

@MainActor
final class RecalculationCoordinator {
    private let healthRepository: HealthRepository
    private let checkInRepository: CheckInRepository
    private let baselineRepository: BaselineRepository
    private let dailyStateRepository: DailyStateRepository
    private let insightRepository: InsightRepository

    private let buildDailyState: BuildDailyStateUseCase
    private let baselineCalculator: CalculateBaselineUseCase
    private let insightAnalysis: InsightAnalysisUseCase

    init(
        healthRepository: HealthRepository,
        checkInRepository: CheckInRepository,
        baselineRepository: BaselineRepository,
        dailyStateRepository: DailyStateRepository,
        insightRepository: InsightRepository
    ) {
        self.healthRepository = healthRepository
        self.checkInRepository = checkInRepository
        self.baselineRepository = baselineRepository
        self.dailyStateRepository = dailyStateRepository
        self.insightRepository = insightRepository

        buildDailyState = BuildDailyStateUseCase(
            healthRepository: healthRepository,
            checkInRepository: checkInRepository,
            baselineRepository: baselineRepository
        )

        baselineCalculator = CalculateBaselineUseCase(
            healthRepository: healthRepository
        )

        insightAnalysis = InsightAnalysisUseCase(
            healthRepository: healthRepository,
            checkInRepository: checkInRepository,
            insightRepository: insightRepository
        )
    }

    func recalculate(
        for date: Date,
        baselineRange: DateRange
    ) async throws {
        try await recalculateBaselines(
            range: baselineRange
        )

        let state = try await buildDailyState.execute(
            for: date
        )

        if let existing = try await dailyStateRepository.fetch(
            for: date
        ) {
            let updated = DailyState(
                id: existing.id,
                date: state.date,
                mood: state.mood,
                energy: state.energy,
                stress: state.stress,
                health: state.health,
                checkIn: state.checkIn,
                deviations: state.deviations,
                baselineStatus: state.baselineStatus,
                generatedAt: state.generatedAt,
                algorithmVersion: state.algorithmVersion
            )

            try await dailyStateRepository.update(
                updated
            )
        } else {
            try await dailyStateRepository.save(
                state
            )
        }

        try await insightAnalysis.execute(
            range: baselineRange
        )

        try await insightRepository.deleteExpired(
            at: Date()
        )
    }

    private func recalculateBaselines(
        range: DateRange
    ) async throws {
        let metrics: [HealthMetric] = [
            .heartRate,
            .restingHeartRate,
            .hrv,
            .respiratoryRate,
            .sleep,
            .steps,
            .activeEnergy,
            .weight
        ]

        for metric in metrics {
            guard let baseline = try await baselineCalculator.execute(
                metric: metric,
                range: range
            ) else {
                continue
            }

            if try await baselineRepository.fetch(
                metric: metric
            ) != nil {
                try await baselineRepository.update(
                    baseline
                )
            } else {
                try await baselineRepository.save(
                    baseline
                )
            }
        }
    }
}
