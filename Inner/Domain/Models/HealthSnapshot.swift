//
//  HealthSnapshot.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct HealthSnapshot: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let date: Date
    let heartRate: Double?
    let restingHeartRate: Double?
    let hrv: Double?
    let respiratoryRate: Double?
    let sleep: SleepSnapshot?
    let steps: Int?
    let activeEnergy: Double?
    let weight: Double?
    let sampleDate: Date?
    let syncedAt: Date?
    let source: String?
    let sourceIdentifier: String?
}
