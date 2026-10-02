//
//  DailyCheckInEntity.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@Model
final class DailyCheckInEntity {
    @Attribute(.unique) var id: UUID
    var date: Date

    var morningMood: Int?
    var morningEnergy: Int?
    var morningStress: Int?
    var subjectiveSleepQuality: Int?

    var eveningMood: Int?
    var eveningEnergy: Int?
    var eveningStress: Int?

    var tags: [String]
    var notes: String?

    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID,
        date: Date,
        morningMood: Int? = nil,
        morningEnergy: Int? = nil,
        morningStress: Int? = nil,
        subjectiveSleepQuality: Int? = nil,
        eveningMood: Int? = nil,
        eveningEnergy: Int? = nil,
        eveningStress: Int? = nil,
        tags: [String] = [],
        notes: String? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.date = date
        self.morningMood = morningMood
        self.morningEnergy = morningEnergy
        self.morningStress = morningStress
        self.subjectiveSleepQuality = subjectiveSleepQuality
        self.eveningMood = eveningMood
        self.eveningEnergy = eveningEnergy
        self.eveningStress = eveningStress
        self.tags = tags
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}