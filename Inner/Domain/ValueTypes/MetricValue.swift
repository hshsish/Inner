//
//  MetricValue.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.

import Foundation

struct MetricValue: Sendable, Equatable {
    let metric: HealthMetric
    let value: Double
    let date: Date
}
