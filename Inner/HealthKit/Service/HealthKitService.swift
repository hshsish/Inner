//
//  HealthKitService.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import Foundation

protocol HealthKitService: Sendable {
    func requestAuthorization() async throws

    func fetchLatestHealthSnapshot(
        for date: Date
    ) async throws -> HealthSnapshot?

    func fetchHealthHistory(
        in range: DateRange
    ) async throws -> [HealthSnapshot]

    func startMonitoring() async throws

    func stopMonitoring() async
}
