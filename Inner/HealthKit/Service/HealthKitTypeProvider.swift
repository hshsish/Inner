//
//  HealthKitTypeProvider.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation
import HealthKit

enum HealthKitTypeProvider {
    static let heartRate = HKQuantityType(.heartRate)

    static let restingHeartRate = HKQuantityType(.restingHeartRate)

    static let heartRateVariability = HKQuantityType(
        .heartRateVariabilitySDNN
    )

    static let respiratoryRate = HKQuantityType(.respiratoryRate)

    static let stepCount = HKQuantityType(.stepCount)

    static let activeEnergyBurned = HKQuantityType(
        .activeEnergyBurned
    )

    static let bodyMass = HKQuantityType(.bodyMass)

    static let sleepAnalysis = HKCategoryType(.sleepAnalysis)

    static let readTypes: Set<HKObjectType> = [
        heartRate,
        restingHeartRate,
        heartRateVariability,
        respiratoryRate,
        stepCount,
        activeEnergyBurned,
        bodyMass,
        sleepAnalysis
    ]
}
