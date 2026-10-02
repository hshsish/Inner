//
//  BaselineSnapshot.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import Foundation

struct BaselineSnapshot: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let metric: HealthMetric
    let median: Double
    let mad: Double
    let range: BaselineRange
    let sampleCount: Int
    let status: BaselineStatus
    let calculationPeriod: DateRange
    let calculatedAt: Date
    let algorithmVersion: Int
}
