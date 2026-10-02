//
//  AppPreferences.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

@MainActor
final class AppPreferences {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var hasCompletedOnboarding: Bool {
        get {
            defaults.bool(forKey: Keys.hasCompletedOnboarding)
        }
        set {
            defaults.set(newValue, forKey: Keys.hasCompletedOnboarding)
        }
    }

    var healthKitRequested: Bool {
        get {
            defaults.bool(forKey: Keys.healthKitRequested)
        }
        set {
            defaults.set(newValue, forKey: Keys.healthKitRequested)
        }
    }

    var notificationsRequested: Bool {
        get {
            defaults.bool(forKey: Keys.notificationsRequested)
        }
        set {
            defaults.set(newValue, forKey: Keys.notificationsRequested)
        }
    }

    var firstBaselineDate: Date? {
        get {
            defaults.object(forKey: Keys.firstBaselineDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: Keys.firstBaselineDate)
        }
    }

    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let healthKitRequested = "healthKitRequested"
        static let notificationsRequested = "notificationsRequested"
        static let firstBaselineDate = "firstBaselineDate"
    }
}