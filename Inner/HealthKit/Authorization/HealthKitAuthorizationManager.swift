//
//  HealthKitAuthorizationManager.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation
import HealthKit

final class HealthKitAuthorizationManager: @unchecked Sendable {
    private let healthStore: HKHealthStore

    init(
        healthStore: HKHealthStore
    ) {
        self.healthStore = healthStore
    }

    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.unavailable
        }

        try await healthStore.requestAuthorization(
            toShare: [],
            read: HealthKitTypeProvider.readTypes
        )
    }

    func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }
}

