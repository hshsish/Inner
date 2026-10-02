//
//  QuantityQueryService.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import HealthKit

final class QuantityQueryService: @unchecked Sendable {
    private let healthStore: HKHealthStore

    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    func samples(
        type: HKQuantityType,
        startDate: Date,
        endDate: Date
    ) async throws -> [HKQuantitySample] {
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: true
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let quantitySamples = samples as? [HKQuantitySample] ?? []
                continuation.resume(returning: quantitySamples)
            }

            healthStore.execute(query)
        }
    }
}