//
//  MetricMetadata.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

struct MetricMetadata: Sendable, Equatable {
    let metric: HealthMetric
    let title: String
    let unit: String
    let higherIsBetter: Bool?
}

enum MetricMetadataProvider {
    static func metadata(for metric: HealthMetric) -> MetricMetadata {
        switch metric {
        case .heartRate:
            MetricMetadata(
                metric: metric,
                title: "Heart Rate",
                unit: "bpm",
                higherIsBetter: nil
            )

        case .restingHeartRate:
            MetricMetadata(
                metric: metric,
                title: "Resting Heart Rate",
                unit: "bpm",
                higherIsBetter: nil
            )

        case .hrv:
            MetricMetadata(
                metric: metric,
                title: "HRV",
                unit: "ms",
                higherIsBetter: nil
            )

        case .respiratoryRate:
            MetricMetadata(
                metric: metric,
                title: "Respiratory Rate",
                unit: "brpm",
                higherIsBetter: nil
            )

        case .sleep:
            MetricMetadata(
                metric: metric,
                title: "Sleep",
                unit: "h",
                higherIsBetter: nil
            )

        case .steps:
            MetricMetadata(
                metric: metric,
                title: "Steps",
                unit: "steps",
                higherIsBetter: nil
            )

        case .activeEnergy:
            MetricMetadata(
                metric: metric,
                title: "Active Energy",
                unit: "kcal",
                higherIsBetter: nil
            )

        case .weight:
            MetricMetadata(
                metric: metric,
                title: "Weight",
                unit: "kg",
                higherIsBetter: nil
            )
        }
    }
}