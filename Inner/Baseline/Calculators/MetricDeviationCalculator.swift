//
//  MetricDeviationCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

import Foundation

struct MetricDeviationCalculator: Sendable {
    func calculate(
        metric: HealthMetric,
        currentValue: Double,
        baseline: BaselineSnapshot
    ) -> MetricDeviation {
        let deviationPercent: Double

        if baseline.median == 0 {
            deviationPercent = currentValue == 0 ? 0 : 100
        } else {
            deviationPercent = (
                (currentValue - baseline.median) /
                abs(baseline.median)
            ) * 100
        }

        let status: DeviationStatus

        if currentValue < baseline.range.lower {
            status = .belowUsual
        } else if currentValue > baseline.range.upper {
            status = .aboveUsual
        } else {
            status = .withinRange
        }
        
        return MetricDeviation(
            id: UUID(),
            metric: metric,
            currentValue: currentValue,
            baselineValue: baseline.median,
            deviationPercent: deviationPercent,
            status: status
        )
    }
}
