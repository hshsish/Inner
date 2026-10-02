//
//  AppConfiguration.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum AppConfiguration {
    static let dataSchemaVersion = 1
    static let baselineAlgorithmVersion = 1
    static let patternAlgorithmVersion = 1
    static let dailyStateAlgorithmVersion = 1
    static let watchPayloadVersion = 1
    static let widgetPayloadVersion = 1

    static let minimumBaselineSamples = 7
    static let establishedBaselineSamples = 28

    static let weakPatternMinimumSamples = 7
    static let moderatePatternMinimumSamples = 15
    static let strongPatternMinimumSamples = 30
}