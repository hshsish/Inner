//
//  InsightRepositoryImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@MainActor
final class InsightRepositoryImpl: InsightRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ insight: Insight) async throws {
        context.insert(try InsightMapper.toEntity(insight))
        try context.save()
    }

    func fetch(id: UUID) async throws -> Insight? {
        let descriptor = FetchDescriptor<InsightEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return try InsightMapper.toDomain(entity)
    }

    func fetchLatest(limit: Int) async throws -> [Insight] {
        var descriptor = FetchDescriptor<InsightEntity>(
            sortBy: [
                SortDescriptor(\.generatedAt, order: .reverse)
            ]
        )

        descriptor.fetchLimit = limit

        return try context.fetch(descriptor).compactMap {
            try InsightMapper.toDomain($0)
        }
    }

    func fetch(in range: DateRange) async throws -> [Insight] {
        let descriptor = FetchDescriptor<InsightEntity>(
            predicate: #Predicate {
                $0.generatedAt >= range.start &&
                $0.generatedAt <= range.end
            },
            sortBy: [
                SortDescriptor(\.generatedAt, order: .reverse)
            ]
        )

        return try context.fetch(descriptor).compactMap {
            try InsightMapper.toDomain($0)
        }
    }

    func delete(id: UUID) async throws {
        let descriptor = FetchDescriptor<InsightEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return
        }

        context.delete(entity)
        try context.save()
    }

    func deleteExpired(at date: Date) async throws {
        let descriptor = FetchDescriptor<InsightEntity>(
            predicate: #Predicate {
                $0.expiresAt != nil && $0.expiresAt! < date
            }
        )

        let entities = try context.fetch(descriptor)

        for entity in entities {
            context.delete(entity)
        }

        if !entities.isEmpty {
            try context.save()
        }
    }
}