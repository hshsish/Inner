//
//  PatternAnalyzer.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct PatternAnalyzer: Sendable {
    private let correlationCalculator: CorrelationCalculator
    private let strengthCalculator: PatternStrengthCalculator

    init(
        correlationCalculator: CorrelationCalculator = CorrelationCalculator(),
        strengthCalculator: PatternStrengthCalculator = PatternStrengthCalculator()
    ) {
        self.correlationCalculator = correlationCalculator
        self.strengthCalculator = strengthCalculator
    }

    func correlation(
        primaryMetric: AnalysisMetric,
        relatedMetric: AnalysisMetric,
        samples: [(primary: Double?, related: Double?)]
    ) -> PatternResult? {
        let validSamples = samples.compactMap { sample -> (Double, Double)? in
            guard
                let primary = sample.primary,
                let related = sample.related,
                primary.isFinite,
                related.isFinite
            else {
                return nil
            }

            return (primary, related)
        }

        guard validSamples.count >= AppConfiguration.weakPatternMinimumSamples else {
            return nil
        }

        let primaryValues = validSamples.map(\.0)
        let relatedValues = validSamples.map(\.1)

        guard let coefficient = correlationCalculator.pearson(
            primaryValues,
            relatedValues
        ) else {
            return nil
        }

        return PatternResult(
            id: UUID(),
            kind: .correlation,
            primaryMetric: primaryMetric,
            relatedMetric: relatedMetric,
            correlationCoefficient: coefficient,
            groupDifference: nil,
            groups: [],
            sampleCount: validSamples.count,
            strength: strengthCalculator.strength(
                coefficient: coefficient,
                sampleCount: validSamples.count
            ),
            calculatedAt: Date(),
            algorithmVersion: AppConfiguration.patternAlgorithmVersion
        )
    }

    func groupedComparison(
        primaryMetric: AnalysisMetric,
        samples: [(group: String, value: Double?)]
    ) -> PatternResult? {
        let validSamples = samples.compactMap { sample -> (String, Double)? in
            guard let value = sample.value, value.isFinite else {
                return nil
            }

            return (sample.group, value)
        }

        guard validSamples.count >= AppConfiguration.weakPatternMinimumSamples else {
            return nil
        }

        let grouped = Dictionary(grouping: validSamples) {
            $0.0
        }

        guard grouped.count >= 2 else {
            return nil
        }

        let groups = grouped.map { label, values in
            PatternGroup(
                id: UUID(),
                label: label,
                sampleCount: values.count,
                averageValue: values.map(\.1).reduce(0, +) /
                    Double(values.count)
            )
        }
        .sorted {
            $0.averageValue > $1.averageValue
        }

        guard
            let highest = groups.first,
            let lowest = groups.last
        else {
            return nil
        }

        let difference = highest.averageValue - lowest.averageValue

        let normalizedDifference: Double

        if lowest.averageValue == 0 {
            normalizedDifference = difference == 0 ? 0 : 1
        } else {
            normalizedDifference = abs(
                difference / abs(lowest.averageValue)
            )
        }

        let strength: PatternStrength

        if validSamples.count >= AppConfiguration.strongPatternMinimumSamples,
           normalizedDifference >= 0.3 {
            strength = .strong
        } else if validSamples.count >= AppConfiguration.moderatePatternMinimumSamples,
                  normalizedDifference >= 0.2 {
            strength = .moderate
        } else {
            strength = .weak
        }

        return PatternResult(
            id: UUID(),
            kind: .groupedComparison,
            primaryMetric: primaryMetric,
            relatedMetric: nil,
            correlationCoefficient: nil,
            groupDifference: difference,
            groups: groups,
            sampleCount: validSamples.count,
            strength: strength,
            calculatedAt: Date(),
            algorithmVersion: AppConfiguration.patternAlgorithmVersion
        )
    }
}