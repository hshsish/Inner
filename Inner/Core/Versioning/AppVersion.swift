//
//  AppVersion.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum AppVersion {
    static let dataSchema = AppConfiguration.dataSchemaVersion
    static let baselineAlgorithm = AppConfiguration.baselineAlgorithmVersion
    static let patternAlgorithm = AppConfiguration.patternAlgorithmVersion
    static let dailyStateAlgorithm = AppConfiguration.dailyStateAlgorithmVersion
    static let watchPayload = AppConfiguration.watchPayloadVersion
    static let widgetPayload = AppConfiguration.widgetPayloadVersion
}