//
//  BaselineRepositoryImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@MainActor
final class BaselineRepositoryImpl: BaselineRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ baseline: BaselineSnapshot) async throws {
        if let existing = try await fetch(metric: baseline.metric) {
            try await update(baseline, existingEntityID: existing.id)
            return
        }

        context.insert(BaselineSnapshotMapper.toEntity(baseline))
        try context.save()
    }

    func update(_ baseline: BaselineSnapshot) async throws {
        try await update(baseline, existingEntityID: baseline.id)
    }

    private func update(
        _ baseline: BaselineSnapshot,
        existingEntityID: UUID
    ) async throws {
        let descriptor = FetchDescriptor<BaselineSnapshotEntity>(
            predicate: #Predicate {
                $0.id == existingEntityID
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            throw PersistenceError.entityNotFound
        }

        entity.metric = baseline.metric.rawValue
        entity.median = baseline.median
        entity.mad = baseline.mad
        entity.rangeLower = baseline.range.lower
        entity.rangeUpper = baseline.range.upper
        entity.sampleCount = baseline.sampleCount
        entity.status = baseline.status.rawValue
        entity.calculationStart = baseline.calculationPeriod.start
        entity.calculationEnd = baseline.calculationPeriod.end
        entity.calculatedAt = baseline.calculatedAt
        entity.algorithmVersion = baseline.algorithmVersion

        try context.save()
    }

    func fetch(metric: HealthMetric) async throws -> BaselineSnapshot? {
        let rawValue = metric.rawValue

        let descriptor = FetchDescriptor<BaselineSnapshotEntity>(
            predicate: #Predicate {
                $0.metric == rawValue
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return BaselineSnapshotMapper.toDomain(entity)
    }

    func fetchAll() async throws -> [BaselineSnapshot] {
        let descriptor = FetchDescriptor<BaselineSnapshotEntity>(
            sortBy: [
                SortDescriptor(\.metric, order: .forward)
            ]
        )

        return try context.fetch(descriptor).compactMap {
            BaselineSnapshotMapper.toDomain($0)
        }
    }

    func delete(metric: HealthMetric) async throws {
        let rawValue = metric.rawValue

        let descriptor = FetchDescriptor<BaselineSnapshotEntity>(
            predicate: #Predicate {
                $0.metric == rawValue
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return
        }

        context.delete(entity)
        try context.save()
    }
}