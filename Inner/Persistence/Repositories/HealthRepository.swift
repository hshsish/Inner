//
//  HealthRepository.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

protocol HealthRepository: Sendable {
    func save(_ snapshot: HealthSnapshot) async throws

    func update(_ snapshot: HealthSnapshot) async throws

    func delete(id: UUID) async throws

    func fetch(id: UUID) async throws -> HealthSnapshot?

    func fetch(for date: Date) async throws -> HealthSnapshot?

    func fetch(in range: DateRange) async throws -> [HealthSnapshot]

    func fetchLatest() async throws -> HealthSnapshot?
}