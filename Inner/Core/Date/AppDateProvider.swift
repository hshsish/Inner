//
//  AppDateProvider.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

struct AppDateProvider: Sendable {
    let calendar: Calendar
    let timeZone: TimeZone

    init(
        calendar: Calendar = .current,
        timeZone: TimeZone = .current
    ) {
        var calendar = calendar
        calendar.timeZone = timeZone

        self.calendar = calendar
        self.timeZone = timeZone
    }

    func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func endOfDay(for date: Date) -> Date {
        calendar.date(
            byAdding: DateComponents(day: 1, second: -1),
            to: startOfDay(for: date)
        ) ?? date
    }

    func dateByAddingDays(
        _ days: Int,
        to date: Date
    ) -> Date {
        calendar.date(
            byAdding: .day,
            value: days,
            to: date
        ) ?? date
    }

    func isSameDay(
        _ lhs: Date,
        _ rhs: Date
    ) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }

    func daysBetween(
        _ start: Date,
        _ end: Date
    ) -> Int {
        calendar.dateComponents(
            [.day],
            from: startOfDay(for: start),
            to: startOfDay(for: end)
        ).day ?? 0
    }
}