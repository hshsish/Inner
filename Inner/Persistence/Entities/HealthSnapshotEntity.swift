//
//  HealthSnapshotEntity.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@Model
final class HealthSnapshotEntity {
    @Attribute(.unique) var id: UUID
    var date: Date

    var heartRate: Double?
    var restingHeartRate: Double?
    var hrv: Double?
    var respiratoryRate: Double?

    var sleepDuration: Double?
    var sleepAwakeDuration: Double?
    var sleepREM: Double?
    var sleepCore: Double?
    var sleepDeep: Double?

    var steps: Int?
    var activeEnergy: Double?
    var weight: Double?

    var sampleDate: Date?
    var syncedAt: Date?
    var source: String?
    var sourceIdentifier: String?

    init(
        id: UUID,
        date: Date,
        heartRate: Double? = nil,
        restingHeartRate: Double? = nil,
        hrv: Double? = nil,
        respiratoryRate: Double? = nil,
        sleepDuration: Double? = nil,
        sleepAwakeDuration: Double? = nil,
        sleepREM: Double? = nil,
        sleepCore: Double? = nil,
        sleepDeep: Double? = nil,
        steps: Int? = nil,
        activeEnergy: Double? = nil,
        weight: Double? = nil,
        sampleDate: Date? = nil,
        syncedAt: Date? = nil,
        source: String? = nil,
        sourceIdentifier: String? = nil
    ) {
        self.id = id
        self.date = date
        self.heartRate = heartRate
        self.restingHeartRate = restingHeartRate
        self.hrv = hrv
        self.respiratoryRate = respiratoryRate
        self.sleepDuration = sleepDuration
        self.sleepAwakeDuration = sleepAwakeDuration
        self.sleepREM = sleepREM
        self.sleepCore = sleepCore
        self.sleepDeep = sleepDeep
        self.steps = steps
        self.activeEnergy = activeEnergy
        self.weight = weight
        self.sampleDate = sampleDate
        self.syncedAt = syncedAt
        self.source = source
        self.sourceIdentifier = sourceIdentifier
    }
}