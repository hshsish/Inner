//
//  DateRange.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import Foundation

struct DateRange: Codable, Sendable, Equatable {
    let start: Date
    let end: Date

    init(
        start: Date,
        end: Date
    ) {
        self.start = start
        self.end = end
    }
}
