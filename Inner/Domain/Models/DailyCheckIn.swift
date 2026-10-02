//
//  DailyCheckIn.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct DailyCheckIn: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let date: Date
    let morningMood: MoodLevel?
    let morningEnergy: EnergyLevel?
    let morningStress: StressLevel?
    let subjectiveSleepQuality: SleepQuality?
    let eveningMood: MoodLevel?
    let eveningEnergy: EnergyLevel?
    let eveningStress: StressLevel?
    let tags: [CheckInTag]
    let notes: String?
    let createdAt: Date
    let updatedAt: Date
}
