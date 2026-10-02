//
//  DeviationStatus.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

enum DeviationStatus: String, Codable, Sendable {
    case withinRange
    case aboveUsual
    case belowUsual
    case significantlyDifferent
}
