//
//  InsightGenerator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//
import Foundation

struct InsightGenerator: Sendable {
    func generate(
        from pattern: PatternResult
    ) -> Insight? {
        guard pattern.sampleCount >= AppConfiguration.weakPatternMinimumSamples else {
            return nil
        }

        guard let type = insightType(for: pattern) else {
            return nil
        }

        return Insight(
            id: UUID(),
            type: type,
            primaryMetric: pattern.primaryMetric,
            relatedMetric: pattern.relatedMetric,
            pattern: pattern,
            sampleCount: pattern.sampleCount,
            strength: pattern.strength,
            generatedAt: Date(),
            expiresAt: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date()
            ),
            algorithmVersion: AppConfiguration.patternAlgorithmVersion
        )
    }

    private func insightType(
        for pattern: PatternResult
    ) -> InsightType? {
        switch pattern.kind {
        case .correlation:
            guard let related = pattern.relatedMetric else {
                return nil
            }

            return correlationType(
                primary: pattern.primaryMetric,
                related: related
            )

        case .groupedComparison:
            return groupedComparisonType(
                primary: pattern.primaryMetric,
                related: pattern.relatedMetric
            )

        case .tagComparison:
            return .tagRelationship
        }
    }

    private func correlationType(
        primary: AnalysisMetric,
        related: AnalysisMetric
    ) -> InsightType? {
        switch (primary, related) {
        case (.sleepDuration, .mood),
             (.mood, .sleepDuration):
            return .sleepMood

        case (.sleepDuration, .energy),
             (.energy, .sleepDuration):
            return .sleepEnergy

        case (.sleepDuration, .stress),
             (.stress, .sleepDuration):
            return .sleepStress

        case (.hrv, .mood),
             (.mood, .hrv):
            return .hrvMood

        case (.hrv, .energy),
             (.energy, .hrv):
            return .hrvEnergy

        case (.steps, .mood),
             (.mood, .steps),
             (.activeEnergy, .mood),
             (.mood, .activeEnergy):
            return .activityMood

        case (.steps, .energy),
             (.energy, .steps),
             (.activeEnergy, .energy),
             (.energy, .activeEnergy):
            return .activityEnergy

        case (.restingHeartRate, .energy),
             (.energy, .restingHeartRate):
            return .restingHeartRateEnergy

        default:
            return nil
        }
    }

    private func groupedComparisonType(
        primary: AnalysisMetric,
        related: AnalysisMetric?
    ) -> InsightType? {
        guard let related else {
            return nil
        }

        return correlationType(
            primary: primary,
            related: related
        )
    }
}
