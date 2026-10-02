//
//  SleepQueryService.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import HealthKit

final class SleepQueryService: @unchecked Sendable {
    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    func samples(
        startDate: Date,
        endDate: Date
    ) async throws -> [HKCategorySample] {
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: true
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HealthKitTypeProvider.sleepAnalysis,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(
                    returning: samples as? [HKCategorySample] ?? []
                )
            }

            healthStore.execute(query)
        }
    }
}