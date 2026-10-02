//
//  InsightRepository.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

protocol InsightRepository: Sendable {
    func save(_ insight: Insight) async throws

    func fetch(id: UUID) async throws -> Insight?

    func fetchLatest(limit: Int) async throws -> [Insight]

    func fetch(in range: DateRange) async throws -> [Insight]

    func delete(id: UUID) async throws

    func deleteExpired(at date: Date) async throws
}