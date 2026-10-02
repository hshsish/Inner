//
//  DailyStateEntity.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@Model
final class DailyStateEntity {
    @Attribute(.unique) var id: UUID
    var date: Date

    var mood: Double?
    var energy: Double?
    var stress: Double?

    var healthSnapshotID: UUID?
    var checkInID: UUID?

    var baselineStatus: String
    var generatedAt: Date
    var algorithmVersion: Int

    init(
        id: UUID,
        date: Date,
        mood: Double? = nil,
        energy: Double? = nil,
        stress: Double? = nil,
        healthSnapshotID: UUID? = nil,
        checkInID: UUID? = nil,
        baselineStatus: String,
        generatedAt: Date,
        algorithmVersion: Int
    ) {
        self.id = id
        self.date = date
        self.mood = mood
        self.energy = energy
        self.stress = stress
        self.healthSnapshotID = healthSnapshotID
        self.checkInID = checkInID
        self.baselineStatus = baselineStatus
        self.generatedAt = generatedAt
        self.algorithmVersion = algorithmVersion
    }
}