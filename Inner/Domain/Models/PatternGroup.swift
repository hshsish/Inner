//
//  PatternGroup.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct PatternGroup: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let label: String
    let sampleCount: Int
    let averageValue: Double
}
