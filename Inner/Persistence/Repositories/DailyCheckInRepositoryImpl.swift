//
//  DailyCheckInRepositoryImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@MainActor
final class DailyCheckInRepositoryImpl: CheckInRepository {
    private let context: ModelContext
    private let calendar: Calendar

    init(
        context: ModelContext,
        calendar: Calendar = .current
    ) {
        self.context = context
        self.calendar = calendar
    }

    func save(_ checkIn: DailyCheckIn) async throws {
        if let existing = try await fetch(for: checkIn.date) {
            try await update(checkIn, existingEntityID: existing.id)
            return
        }

        context.insert(DailyCheckInMapper.toEntity(checkIn))
        try context.save()
    }

    func update(_ checkIn: DailyCheckIn) async throws {
        try await update(checkIn, existingEntityID: checkIn.id)
    }

    private func update(
        _ checkIn: DailyCheckIn,
        existingEntityID: UUID
    ) async throws {
        let descriptor = FetchDescriptor<DailyCheckInEntity>(
            predicate: #Predicate {
                $0.id == existingEntityID
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            throw PersistenceError.entityNotFound
        }

        entity.date = checkIn.date
        entity.morningMood = checkIn.morningMood?.rawValue
        entity.morningEnergy = checkIn.morningEnergy?.rawValue
        entity.morningStress = checkIn.morningStress?.rawValue
        entity.subjectiveSleepQuality = checkIn.subjectiveSleepQuality?.rawValue
        entity.eveningMood = checkIn.eveningMood?.rawValue
        entity.eveningEnergy = checkIn.eveningEnergy?.rawValue
        entity.eveningStress = checkIn.eveningStress?.rawValue
        entity.tags = checkIn.tags.map(\.rawValue)
        entity.notes = checkIn.notes
        entity.updatedAt = checkIn.updatedAt

        try context.save()
    }

    func delete(id: UUID) async throws {
        let descriptor = FetchDescriptor<DailyCheckInEntity>(
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

    func fetch(id: UUID) async throws -> DailyCheckIn? {
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

    func fetch(for date: Date) async throws -> DailyCheckIn? {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(
            byAdding: .day,
            value: 1,
            to: start
        )!

        let descriptor = FetchDescriptor<DailyCheckInEntity>(
            predicate: #Predicate {
                $0.date >= start && $0.date < end
            }
        )

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return DailyCheckInMapper.toDomain(entity)
    }

    func fetch(in range: DateRange) async throws -> [DailyCheckIn] {
        let start = range.start
        let end = range.end

        let descriptor = FetchDescriptor<DailyCheckInEntity>(
            predicate: #Predicate {
                $0.date >= start && $0.date <= end
            },
            sortBy: [
                SortDescriptor(\.date, order: .forward)
            ]
        )

        return try context.fetch(descriptor).map {
            DailyCheckInMapper.toDomain($0)
        }
    }

    func fetchLatest(limit: Int) async throws -> [DailyCheckIn] {
        var descriptor = FetchDescriptor<DailyCheckInEntity>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )

        descriptor.fetchLimit = limit

        return try context.fetch(descriptor).map {
            DailyCheckInMapper.toDomain($0)
        }
    }
}