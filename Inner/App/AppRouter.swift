//
//  AppRouter.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import Foundation
import Observation

@MainActor
@Observable
final class AppRouter {
    var route: AppRoute = .today

    func show(_ route: AppRoute) {
        self.route = route
    }
}

enum AppRoute: Hashable {
    case today
    case history
    case insights
    case settings
    case morningCheckIn
    case eveningCheckIn
    case baseline(HealthMetric)
    case day(Date)
}
