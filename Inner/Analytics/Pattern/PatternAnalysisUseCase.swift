//
//  PatternAnalysisUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct PatternAnalysisUseCase: Sendable {
    private let analyzer: PatternAnalyzer

    init(
        analyzer: PatternAnalyzer = PatternAnalyzer()
    ) {
        self.analyzer = analyzer
    }

    func executeCorrelation(
        primaryMetric: AnalysisMetric,
        relatedMetric: AnalysisMetric,
        samples: [(primary: Double?, related: Double?)]
    ) -> PatternResult? {
        analyzer.correlation(
            primaryMetric: primaryMetric,
            relatedMetric: relatedMetric,
            samples: samples
        )
    }

    func executeGroupedComparison(
        primaryMetric: AnalysisMetric,
        samples: [(group: String, value: Double?)]
    ) -> PatternResult? {
        analyzer.groupedComparison(
            primaryMetric: primaryMetric,
            samples: samples
        )
    }
}