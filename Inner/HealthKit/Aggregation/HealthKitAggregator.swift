//
//  HealthKitAggregator.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation
import HealthKit

struct HealthKitAggregator: Sendable {
    func median(_ values: [Double]) -> Double? {
        guard !values.isEmpty else {
            return nil
        }

        let sorted = values.sorted()
        let middle = sorted.count / 2

        if sorted.count.isMultiple(of: 2) {
            return (sorted[middle - 1] + sorted[middle]) / 2
        }

        return sorted[middle]
    }

    func latest(_ samples: [HKQuantitySample]) -> HKQuantitySample? {
        samples.max {
            $0.endDate < $1.endDate
        }
    }

    func sum(
        _ samples: [HKQuantitySample],
        unit: HKUnit
    ) -> Double {
        samples.reduce(0) { result, sample in
            result + sample.quantity.doubleValue(for: unit)
        }
    }
}
