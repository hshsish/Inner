//
//  DailyStateRepositoryImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//
import Foundation
import SwiftData

@MainActor
final class DailyStateRepositoryImpl: DailyStateRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ state: DailyState) async throws {
        if let existing = try fetchEntity(for: state.date) {
            DailyStateMapper.update(
                existing,
                from: state
            )

            try context.save()
            return
        }

        let entity = DailyStateMapper.toEntity(state)

        context.insert(entity)

        try context.save()
    }

    func update(_ state: DailyState) async throws {
        guard let entity = try fetchEntity(id: state.id) else {
            throw PersistenceError.entityNotFound
        }

        DailyStateMapper.update(
            entity,
            from: state
        )

        try context.save()
    }

    func fetch(for date: Date) async throws -> DailyState? {
        guard let entity = try fetchEntity(for: date) else {
            return nil
        }

        return try await makeDomainModel(
            from: entity
        )
    }

    func fetch(in range: DateRange) async throws -> [DailyState] {
        let start = range.start
        let end = range.end

        let descriptor = FetchDescriptor<DailyStateEntity>(
            predicate: #Predicate {
                $0.date >= start &&
                $0.date <= end
            },
            sortBy: [
                SortDescriptor(
                    \.date,
                    order: .forward
                )
            ]
        )

        let entities = try context.fetch(descriptor)

        var result: [DailyState] = []

        for entity in entities {
            if let model = try await makeDomainModel(
                from: entity
            ) {
                result.append(model)
            }
        }

        return result
    }

    func fetchLatest() async throws -> DailyState? {
        var descriptor = FetchDescriptor<DailyStateEntity>(
            sortBy: [
                SortDescriptor(
                    \.date,
                    order: .reverse
                )
            ]
        )

        descriptor.fetchLimit = 1

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return try await makeDomainModel(
            from: entity
        )
    }

    private func fetchEntity(
        id: UUID
    ) throws -> DailyStateEntity? {
        let descriptor = FetchDescriptor<DailyStateEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        return try context.fetch(descriptor).first
    }

    private func fetchEntity(
        for date: Date
    ) throws -> DailyStateEntity? {
        let descriptor = FetchDescriptor<DailyStateEntity>(
            predicate: #Predicate {
                $0.date == date
            }
        )

        return try context.fetch(descriptor).first
    }

    private func makeDomainModel(
        from entity: DailyStateEntity
    ) async throws -> DailyState? {
        let health: HealthSnapshot?

        if let healthSnapshotID = entity.healthSnapshotID {
            health = try await fetchHealthSnapshot(
                id: healthSnapshotID
            )
        } else {
            health = nil
        }

        let checkIn: DailyCheckIn?

        if let checkInID = entity.checkInID {
            checkIn = try await fetchCheckIn(
                id: checkInID
            )
        } else {
            checkIn = nil
        }

        guard
            let baselineStatus = BaselineStatus(
                rawValue: entity.baselineStatus
            )
        else {
            throw PersistenceError.invalidData
        }

        return DailyState(
            id: entity.id,
            date: entity.date,
            mood: entity.mood,
            energy: entity.energy,
            stress: entity.stress,
            health: health,
            checkIn: checkIn,
            deviations: [],
            baselineStatus: baselineStatus,
            generatedAt: entity.generatedAt,
            algorithmVersion: entity.algorithmVersion
        )
    }

    private func fetchHealthSnapshot(
        id: UUID
    ) async throws -> HealthSnapshot? {
        let descriptor = FetchDescriptor<HealthSnapshotEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return HealthSnapshotMapper.toDomain(entity)
    }

    private func fetchCheckIn(
        id: UUID
    ) async throws -> DailyCheckIn? {
        let descriptor = FetchDescriptor<DailyCheckInEntity>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return DailyCheckInMapper.toDomain(entity)
    }
}
