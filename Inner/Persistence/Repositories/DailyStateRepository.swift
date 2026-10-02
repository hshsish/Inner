//
//  DailyStateRepository.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

protocol DailyStateRepository: Sendable {
    func save(_ state: DailyState) async throws
    func update(_ state: DailyState) async throws
    func fetch(for date: Date) async throws -> DailyState?
    func fetch(in range: DateRange) async throws -> [DailyState]
    func fetchLatest() async throws -> DailyState?
}