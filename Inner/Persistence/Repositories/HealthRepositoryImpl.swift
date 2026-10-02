//
//  HealthRepositoryImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@MainActor
final class HealthRepositoryImpl: HealthRepository {
    private let context: ModelContext
    private let calendar: Calendar

    init(
        context: ModelContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    func save(_ snapshot: HealthSnapshot) async throws {
        let entity = HealthSnapshotMapper.toEntity(snapshot)
        context.insert(entity)
        try context.save()
    }

    func update(_ snapshot: HealthSnapshot) async throws {
        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.id == snapshot.id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            throw PersistenceError.entityNotFound
        }

        entity.heartRate = snapshot.heartRate
        entity.restingHeartRate = snapshot.restingHeartRate
        entity.hrv = snapshot.hrv
        entity.respiratoryRate = snapshot.respiratoryRate
        entity.sleepDuration = snapshot.sleep?.duration
        entity.sleepAwakeDuration = snapshot.sleep?.awakeDuration
        entity.sleepREM = snapshot.sleep?.remDuration
        entity.sleepCore = snapshot.sleep?.coreDuration
        entity.sleepDeep = snapshot.sleep?.deepDuration
        entity.steps = snapshot.steps
        entity.activeEnergy = snapshot.activeEnergy
        entity.weight = snapshot.weight
        entity.sampleDate = snapshot.sampleDate
        entity.syncedAt = snapshot.syncedAt
        entity.source = snapshot.source
        entity.sourceIdentifier = snapshot.sourceIdentifier

        try context.save()
    }

    func delete(id: UUID) async throws {
        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            throw PersistenceError.entityNotFound
        }

        context.delete(entity)
        try context.save()
    }

    func fetch(id: UUID) async throws -> HealthSnapshot? {
        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        return try context.fetch(descriptor).first.map {
            HealthSnapshotMapper.toDomain($0)
        }
    }

    func fetch(for date: Date) async throws -> HealthSnapshot? {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)!

        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.date >= start && $0.date < end
            }
        )

        return try context.fetch(descriptor).first.map {
            HealthSnapshotMapper.toDomain($0)
        }
    }

    func fetch(in range: DateRange) async throws -> [HealthSnapshot] {
        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.date >= range.start && $0.date <= range.end
            },
            sortBy: [
                SortDescriptor(\.date, order: .forward)
            ]
        )

        return try context.fetch(descriptor).map {
            HealthSnapshotMapper.toDomain($0)
        }
    }

    func fetchLatest() async throws -> HealthSnapshot? {
        var descriptor = FetchDescriptor<HealthSnapshotEntity>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )

        descriptor.fetchLimit = 1

        return try context.fetch(descriptor).first.map {
            HealthSnapshotMapper.toDomain($0)
        }
    }
}