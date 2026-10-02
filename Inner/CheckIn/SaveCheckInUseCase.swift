//
//  SaveCheckInUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

@MainActor
struct SaveCheckInUseCase {
    private let repository: CheckInRepository
    private let dateProvider: AppDateProvider

    init(
        repository: CheckInRepository,
        dateProvider: AppDateProvider
    ) {
        self.repository = repository
        self.dateProvider = dateProvider
    }

    func execute(
        _ checkIn: DailyCheckIn
    ) async throws {
        let day = dateProvider.startOfDay(
            for: checkIn.date
        )

        if let existing = try await repository.fetch(
            for: day
        ) {
            let updated = DailyCheckIn(
                id: existing.id,
                date: day,
                morningMood: checkIn.morningMood ?? existing.morningMood,
                morningEnergy: checkIn.morningEnergy ?? existing.morningEnergy,
                morningStress: checkIn.morningStress ?? existing.morningStress,
                subjectiveSleepQuality: checkIn.subjectiveSleepQuality
                    ?? existing.subjectiveSleepQuality,
                eveningMood: checkIn.eveningMood ?? existing.eveningMood,
                eveningEnergy: checkIn.eveningEnergy ?? existing.eveningEnergy,
                eveningStress: checkIn.eveningStress ?? existing.eveningStress,
                tags: checkIn.tags.isEmpty
                    ? existing.tags
                    : checkIn.tags,
                notes: checkIn.notes ?? existing.notes,
                createdAt: existing.createdAt,
                updatedAt: Date()
            )

            try await repository.update(updated)
        } else {
            let newCheckIn = DailyCheckIn(
                id: checkIn.id,
                date: day,
                morningMood: checkIn.morningMood,
                morningEnergy: checkIn.morningEnergy,
                morningStress: checkIn.morningStress,
                subjectiveSleepQuality: checkIn.subjectiveSleepQuality,
                eveningMood: checkIn.eveningMood,
                eveningEnergy: checkIn.eveningEnergy,
                eveningStress: checkIn.eveningStress,
                tags: checkIn.tags,
                notes: checkIn.notes,
                createdAt: checkIn.createdAt,
                updatedAt: Date()
            )

            try await repository.save(newCheckIn)
        }
    }
}