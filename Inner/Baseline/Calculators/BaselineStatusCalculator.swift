//
//  BaselineStatusCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

struct BaselineStatusCalculator: Sendable {
    func status(for sampleCount: Int) -> BaselineStatus {
        switch sampleCount {
        case 0...6:
            return .calibrating
        case 7...13:
            return .building
        case 14...27:
            return .limited
        default:
            return .established
        }
    }
}