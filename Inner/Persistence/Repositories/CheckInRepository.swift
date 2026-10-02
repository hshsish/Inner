//
//  CheckInRepository.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

protocol CheckInRepository: Sendable {
    func save(_ checkIn: DailyCheckIn) async throws

    func update(_ checkIn: DailyCheckIn) async throws

    func delete(id: UUID) async throws

    func fetch(id: UUID) async throws -> DailyCheckIn?

    func fetch(for date: Date) async throws -> DailyCheckIn?

    func fetch(in range: DateRange) async throws -> [DailyCheckIn]

    func fetchLatest(limit: Int) async throws -> [DailyCheckIn]
}