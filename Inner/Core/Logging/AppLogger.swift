//
//  AppLogger.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import os

enum AppLogger {
    private static let subsystem = "fobos.Inner"

    static let app = Logger(
        subsystem: subsystem,
        category: "app"
    )

    static let persistence = Logger(
        subsystem: subsystem,
        category: "persistence"
    )

    static let healthKit = Logger(
        subsystem: subsystem,
        category: "healthKit"
    )

    static let analytics = Logger(
        subsystem: subsystem,
        category: "analytics"
    )

    static let sync = Logger(
        subsystem: subsystem,
        category: "sync"
    )
}