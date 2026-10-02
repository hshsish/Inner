//
//  SleepProcessor.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import HealthKit

struct SleepProcessor: Sendable {
    func process(
        samples: [HKCategorySample]
    ) -> SleepSnapshot? {
        guard !samples.isEmpty else {
            return nil
        }

        var awake: TimeInterval = 0
        var rem: TimeInterval = 0
        var core: TimeInterval = 0
        var deep: TimeInterval = 0

        for sample in samples {
            let duration = sample.endDate.timeIntervalSince(
                sample.startDate
            )

            guard duration > 0 else {
                continue
            }

            switch sample.value {
            case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                rem += duration

            case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                core += duration

            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                deep += duration

            case HKCategoryValueSleepAnalysis.awake.rawValue:
                awake += duration

            default:
                break
            }
        }

        let total = rem + core + deep

        guard total > 0 else {
            return nil
        }

        return SleepSnapshot(
            duration: total,
            awakeDuration: awake,
            remDuration: rem,
            coreDuration: core,
            deepDuration: deep
        )
    }
}