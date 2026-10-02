//
//  CheckInViewModel.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class CheckInViewModel {
    private let saveCheckIn: SaveCheckInUseCase
    private let getCheckIn: GetCheckInUseCase
    private let dateProvider: AppDateProvider

    let period: CheckInPeriod
    let date: Date

    var mood: MoodLevel?
    var energy: EnergyLevel?
    var stress: StressLevel?
    var sleepQuality: SleepQuality?
    var tags: [CheckInTag] = []
    var notes = ""

    var isLoading = false
    var isSaving = false
    var errorMessage: String?

    init(
        period: CheckInPeriod,
        date: Date = Date(),
        saveCheckIn: SaveCheckInUseCase,
        getCheckIn: GetCheckInUseCase,
        dateProvider: AppDateProvider
    ) {
        self.period = period
        self.date = date
        self.saveCheckIn = saveCheckIn
        self.getCheckIn = getCheckIn
        self.dateProvider = dateProvider
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let day = dateProvider.startOfDay(
                for: date
            )

            guard let checkIn = try await getCheckIn.execute(
                for: day
            ) else {
                isLoading = false
                return
            }

            switch period {
            case .morning:
                mood = checkIn.morningMood
                energy = checkIn.morningEnergy
                stress = checkIn.morningStress
                sleepQuality = checkIn.subjectiveSleepQuality

            case .evening:
                mood = checkIn.eveningMood
                energy = checkIn.eveningEnergy
                stress = checkIn.eveningStress
                tags = checkIn.tags
                notes = checkIn.notes ?? ""
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func save() async -> Bool {
        isSaving = true
        errorMessage = nil

        do {
            let existing = try await getCheckIn.execute(
                for: dateProvider.startOfDay(
                    for: date
                )
            )

            let checkIn = DailyCheckIn(
                id: existing?.id ?? UUID(),
                date: dateProvider.startOfDay(
                    for: date
                ),
                morningMood: period == .morning
                    ? mood
                    : existing?.morningMood,
                morningEnergy: period == .morning
                    ? energy
                    : existing?.morningEnergy,
                morningStress: period == .morning
                    ? stress
                    : existing?.morningStress,
                subjectiveSleepQuality: period == .morning
                    ? sleepQuality
                    : existing?.subjectiveSleepQuality,
                eveningMood: period == .evening
                    ? mood
                    : existing?.eveningMood,
                eveningEnergy: period == .evening
                    ? energy
                    : existing?.eveningEnergy,
                eveningStress: period == .evening
                    ? stress
                    : existing?.eveningStress,
                tags: period == .evening
                    ? tags
                    : existing?.tags ?? [],
                notes: period == .evening
                    ? notes.nilIfEmpty
                    : existing?.notes,
                createdAt: existing?.createdAt ?? Date(),
                updatedAt: Date()
            )

            try await saveCheckIn.execute(
                checkIn
            )

            isSaving = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isSaving = false
            return false
        }
    }

    var canSave: Bool {
        mood != nil &&
        energy != nil &&
        stress != nil
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

