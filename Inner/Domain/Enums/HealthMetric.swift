//
//  HealthMetric.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

enum HealthMetric: String, Codable, Sendable, Equatable {
    case heartRate
    case restingHeartRate
    case hrv
    case respiratoryRate
    case sleep
    case steps
    case activeEnergy
    case weight
}
