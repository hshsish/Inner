//
//  BaselineRepository.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

protocol BaselineRepository: Sendable {
    func save(_ baseline: BaselineSnapshot) async throws

    func update(_ baseline: BaselineSnapshot) async throws

    func fetch(metric: HealthMetric) async throws -> BaselineSnapshot?

    func fetchAll() async throws -> [BaselineSnapshot]

    func delete(metric: HealthMetric) async throws
}