//
//  BaselineCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct BaselineCalculator: Sendable {
    private let rangeMultiplier: Double
    private let statusCalculator: BaselineStatusCalculator

    init(
        rangeMultiplier: Double = 2.5,
        statusCalculator: BaselineStatusCalculator = BaselineStatusCalculator()
    ) {
        self.rangeMultiplier = rangeMultiplier
        self.statusCalculator = statusCalculator
    }

    func calculate(
        metric: HealthMetric,
        values: [(date: Date, value: Double)]
    ) -> BaselineSnapshot? {
        let validValues = values.filter {
            $0.value.isFinite
        }

        guard !validValues.isEmpty else {
            return nil
        }

        let numericValues = validValues.map(\.value)

        let median = calculateMedian(numericValues)

        let mad = calculateMAD(
            values: numericValues,
            median: median
        )

        let deviation = rangeMultiplier * mad

        let lower = max(
            0,
            median - deviation
        )

        let upper = median + deviation

        let dates = validValues.map(\.date)

        guard
            let firstDate = dates.min(),
            let lastDate = dates.max()
        else {
            return nil
        }

        return BaselineSnapshot(
            id: UUID(),
            metric: metric,
            median: median,
            mad: mad,
            range: BaselineRange(
                lower: lower,
                upper: upper
            ),
            sampleCount: numericValues.count,
            status: statusCalculator.status(
                for: numericValues.count
            ),
            calculationPeriod: DateRange(
                start: firstDate,
                end: lastDate
            ),
            calculatedAt: Date(),
            algorithmVersion: AppConfiguration.baselineAlgorithmVersion
        )
    }

    private func calculateMedian(
        _ values: [Double]
    ) -> Double {
        let sorted = values.sorted()
        let middle = sorted.count / 2

        if sorted.count.isMultiple(of: 2) {
            return (
                sorted[middle - 1] +
                sorted[middle]
            ) / 2
        }

        return sorted[middle]
    }

    private func calculateMAD(
        values: [Double],
        median: Double
    ) -> Double {
        let deviations = values.map {
            abs($0 - median)
        }

        return calculateMedian(deviations)
    }
}
