//
//  BaselineSnapshotEntity.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@Model
final class BaselineSnapshotEntity {
    @Attribute(.unique) var id: UUID
    var metric: String
    var median: Double
    var mad: Double
    var rangeLower: Double
    var rangeUpper: Double
    var sampleCount: Int
    var status: String
    var calculationStart: Date
    var calculationEnd: Date
    var calculatedAt: Date
    var algorithmVersion: Int

    init(
        id: UUID,
        metric: String,
        median: Double,
        mad: Double,
        rangeLower: Double,
        rangeUpper: Double,
        sampleCount: Int,
        status: String,
        calculationStart: Date,
        calculationEnd: Date,
        calculatedAt: Date,
        algorithmVersion: Int
    ) {
        self.id = id
        self.metric = metric
        self.median = median
        self.mad = mad
        self.rangeLower = rangeLower
        self.rangeUpper = rangeUpper
        self.sampleCount = sampleCount
        self.status = status
        self.calculationStart = calculationStart
        self.calculationEnd = calculationEnd
        self.calculatedAt = calculatedAt
        self.algorithmVersion = algorithmVersion
    }
}