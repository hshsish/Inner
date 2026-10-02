//
//  MetricDeviation.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct MetricDeviation: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let metric: HealthMetric
    let currentValue: Double
    let baselineValue: Double
    let deviationPercent: Double
    let status: DeviationStatus
}
