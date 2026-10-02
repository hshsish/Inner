//
//  InsightEntity.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@Model
final class InsightEntity {
    @Attribute(.unique) var id: UUID

    var type: String
    var primaryMetric: String
    var relatedMetric: String?

    var patternData: Data

    var sampleCount: Int
    var strength: String

    var generatedAt: Date
    var expiresAt: Date?
    var algorithmVersion: Int

    init(
        id: UUID,
        type: String,
        primaryMetric: String,
        relatedMetric: String?,
        patternData: Data,
        sampleCount: Int,
        strength: String,
        generatedAt: Date,
        expiresAt: Date?,
        algorithmVersion: Int
    ) {
        self.id = id
        self.type = type
        self.primaryMetric = primaryMetric
        self.relatedMetric = relatedMetric
        self.patternData = patternData
        self.sampleCount = sampleCount
        self.strength = strength
        self.generatedAt = generatedAt
        self.expiresAt = expiresAt
        self.algorithmVersion = algorithmVersion
    }
}