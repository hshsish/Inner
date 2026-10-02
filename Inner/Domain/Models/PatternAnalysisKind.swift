//
//  PatternAnalysisKind.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

enum PatternAnalysisKind: String, Codable, Sendable {
    case correlation
    case groupedComparison
    case tagComparison
}

struct PatternResult: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let kind: PatternAnalysisKind
    let primaryMetric: AnalysisMetric
    let relatedMetric: AnalysisMetric?
    let correlationCoefficient: Double?
    let groupDifference: Double?
    let groups: [PatternGroup]
    let sampleCount: Int
    let strength: PatternStrength
    let calculatedAt: Date
    let algorithmVersion: Int
}
