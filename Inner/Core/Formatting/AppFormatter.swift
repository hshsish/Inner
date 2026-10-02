//
//  AppFormatter.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum AppFormatter {
    static func integer(_ value: Int) -> String {
        value.formatted()
    }

    static func decimal(
        _ value: Double,
        maximumFractionDigits: Int = 1
    ) -> String {
        value.formatted(
            .number.precision(
                .fractionLength(0...maximumFractionDigits)
            )
        )
    }

    static func percentage(
        _ value: Double,
        maximumFractionDigits: Int = 0
    ) -> String {
        "\(decimal(value, maximumFractionDigits: maximumFractionDigits))%"
    }

    static func duration(_ interval: TimeInterval) -> String {
        let totalMinutes = max(0, Int(interval / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }

        return "\(minutes)m"
    }

//    static func date(
//        _ date: Date,
//        style: Date.FormatStyle.DateStyle = .medium
//    ) -> String {
//        date.formatted(
//            .dateTime
//                .locale(.current)
//                .timeZone(.current)
//                .dateStyle(style)
//        )
//    }
}
