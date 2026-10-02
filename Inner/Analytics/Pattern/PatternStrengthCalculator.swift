//
//  PatternStrengthCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct PatternStrengthCalculator: Sendable {
    func strength(
        coefficient: Double,
        sampleCount: Int
    ) -> PatternStrength {
        let absoluteCoefficient = abs(coefficient)

        if sampleCount >= AppConfiguration.strongPatternMinimumSamples,
           absoluteCoefficient >= 0.6 {
            return .strong
        }

        if sampleCount >= AppConfiguration.moderatePatternMinimumSamples,
           absoluteCoefficient >= 0.4 {
            return .moderate
        }

        return .weak
    }
}