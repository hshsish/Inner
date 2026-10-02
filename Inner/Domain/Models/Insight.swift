//
//  Insight.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct Insight: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let type: InsightType
    let primaryMetric: AnalysisMetric
    let relatedMetric: AnalysisMetric?
    let pattern: PatternResult
    let sampleCount: Int
    let strength: PatternStrength
    let generatedAt: Date
    let expiresAt: Date?
    let algorithmVersion: Int
}
