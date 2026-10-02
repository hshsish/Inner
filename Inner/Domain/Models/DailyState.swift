//
//  DailyState.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct DailyState: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let date: Date
    let mood: Double?
    let energy: Double?
    let stress: Double?
    let health: HealthSnapshot?
    let checkIn: DailyCheckIn?
    let deviations: [MetricDeviation]
    let baselineStatus: BaselineStatus
    let generatedAt: Date
    let algorithmVersion: Int
}
