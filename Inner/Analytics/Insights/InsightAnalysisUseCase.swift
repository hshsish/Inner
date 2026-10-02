//
//  InsightAnalysisUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import Foundation

struct InsightAnalysisUseCase: Sendable {
    private let healthRepository: HealthRepository
    private let checkInRepository: CheckInRepository
    private let patternAnalyzer: PatternAnalyzer
    private let insightGenerator: InsightGenerator
    private let insightRepository: InsightRepository

    init(
        healthRepository: HealthRepository,
        checkInRepository: CheckInRepository,
        insightRepository: InsightRepository,
        patternAnalyzer: PatternAnalyzer = PatternAnalyzer(),
        insightGenerator: InsightGenerator = InsightGenerator()
    ) {
        self.healthRepository = healthRepository
        self.checkInRepository = checkInRepository
        self.insightRepository = insightRepository
        self.patternAnalyzer = patternAnalyzer
        self.insightGenerator = insightGenerator
    }

    func execute(
        range: DateRange
    ) async throws {
        let healthSnapshots = try await healthRepository.fetch(
            in: range
        )

        let checkIns = try await checkInRepository.fetch(
            in: range
        )

        let checkInsByDate = Dictionary(
            uniqueKeysWithValues: checkIns.map {
                (
                    Calendar.current.startOfDay(for: $0.date),
                    $0
                )
            }
        )

        let healthByDate = Dictionary(
            uniqueKeysWithValues: healthSnapshots.map {
                (
                    Calendar.current.startOfDay(for: $0.date),
                    $0
                )
            }
        )

        let healthDates = Set(
            healthByDate.keys
        )

        let checkInDates = Set(
            checkInsByDate.keys
        )

        let dates = healthDates.union(
            checkInDates
        )

        try await generate(
            primaryMetric: .sleepDuration,
            relatedMetric: .mood,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .sleepDuration,
            relatedMetric: .energy,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .sleepDuration,
            relatedMetric: .stress,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .hrv,
            relatedMetric: .mood,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .hrv,
            relatedMetric: .energy,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .steps,
            relatedMetric: .mood,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .steps,
            relatedMetric: .energy,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .activeEnergy,
            relatedMetric: .mood,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .activeEnergy,
            relatedMetric: .energy,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )

        try await generate(
            primaryMetric: .restingHeartRate,
            relatedMetric: .energy,
            dates: dates,
            healthByDate: healthByDate,
            checkInsByDate: checkInsByDate
        )
    }

    private func generate(
        primaryMetric: AnalysisMetric,
        relatedMetric: AnalysisMetric,
        dates: Set<Date>,
        healthByDate: [Date: HealthSnapshot],
        checkInsByDate: [Date: DailyCheckIn]
    ) async throws {
        var samples: [(primary: Double?, related: Double?)] = []

        for date in dates {
            let health = healthByDate[date]
            let checkIn = checkInsByDate[date]

            let primary = value(
                for: primaryMetric,
                health: health,
                checkIn: checkIn
            )

            let related = value(
                for: relatedMetric,
                health: health,
                checkIn: checkIn
            )

            samples.append(
                (
                    primary: primary,
                    related: related
                )
            )
        }

        guard let pattern = patternAnalyzer.correlation(
            primaryMetric: primaryMetric,
            relatedMetric: relatedMetric,
            samples: samples
        ) else {
            return
        }

        guard let insight = insightGenerator.generate(
            from: pattern
        ) else {
            return
        }

        let existing = try await insightRepository.fetchLatest(
            limit: 100
        )

        for oldInsight in existing
        where oldInsight.type == insight.type {
            try await insightRepository.delete(
                id: oldInsight.id
            )
        }

        try await insightRepository.save(
            insight
        )
    }

    private func value(
        for metric: AnalysisMetric,
        health: HealthSnapshot?,
        checkIn: DailyCheckIn?
    ) -> Double? {
        switch metric {
        case .mood:
            return checkIn.flatMap {
                $0.eveningMood.map {
                    Double($0.rawValue)
                }
                ?? $0.morningMood.map {
                    Double($0.rawValue)
                }
            }

        case .energy:
            return checkIn.flatMap {
                $0.eveningEnergy.map {
                    Double($0.rawValue)
                }
                ?? $0.morningEnergy.map {
                    Double($0.rawValue)
                }
            }

        case .stress:
            return checkIn.flatMap {
                $0.eveningStress.map {
                    Double($0.rawValue)
                }
                ?? $0.morningStress.map {
                    Double($0.rawValue)
                }
            }

        case .heartRate:
            return health?.heartRate

        case .restingHeartRate:
            return health?.restingHeartRate

        case .hrv:
            return health?.hrv

        case .respiratoryRate:
            return health?.respiratoryRate

        case .sleepDuration:
            return health?.sleep.map {
                $0.duration / 3600
            }

        case .steps:
            return health?.steps.map(Double.init)

        case .activeEnergy:
            return health?.activeEnergy

        case .weight:
            return health?.weight
        }
    }
}
