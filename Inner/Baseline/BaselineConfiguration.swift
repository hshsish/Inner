//
//  BaselineConfiguration.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct BaselineConfiguration: Sendable {
    let calculationDays: Int
    let rangeMultiplier: Double
    let algorithmVersion: Int

    static let `default` = BaselineConfiguration(
        calculationDays: 90,
        rangeMultiplier: 2.5,
        algorithmVersion: 1
    )
}