//
//  HistoryViewModel.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HistoryViewModel {
    private let healthRepository: HealthRepository
    private let checkInRepository: CheckInRepository
    private let dateProvider: AppDateProvider

    var period: HistoryPeriod = .thirtyDays
    var days: [HistoryDay] = []
    var isLoading = false
    var errorMessage: String?

    init(
        healthRepository: HealthRepository,
        checkInRepository: CheckInRepository,
        dateProvider: AppDateProvider
    ) {
        self.healthRepository = healthRepository
        self.checkInRepository = checkInRepository
        self.dateProvider = dateProvider
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let endDate = Date()

            let startDate = dateProvider.calendar.date(
                byAdding: .day,
                value: -(period.rawValue - 1),
                to: dateProvider.startOfDay(for: endDate)
            ) ?? endDate

            let range = DateRange(
                start: startDate,
                end: endDate
            )

            let healthRecords = try await healthRepository.fetch(
                in: range
            )

            var result: [HistoryDay] = []

            for offset in 0..<period.rawValue {
                guard let date = dateProvider.calendar.date(
                    byAdding: .day,
                    value: offset,
                    to: startDate
                ) else {
                    continue
                }

                let day = dateProvider.startOfDay(for: date)

                let health = healthRecords.first {
                    dateProvider.startOfDay(
                        for: $0.date
                    ) == day
                }

                let checkIn = try await checkInRepository.fetch(
                    for: day
                )

                result.append(
                    HistoryDay(
                        date: day,
                        mood: moodValue(
                            from: checkIn
                        ),
                        energy: energyValue(
                            from: checkIn
                        ),
                        stress: stressValue(
                            from: checkIn
                        ),
                        hrv: health?.hrv,
                        restingHeartRate: health?.restingHeartRate,
                        sleepDuration: health?.sleep?.duration,
                        steps: health?.steps
                    )
                )
            }

            days = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func select(
        _ period: HistoryPeriod
    ) async {
        self.period = period
        await load()
    }

    private func moodValue(
        from checkIn: DailyCheckIn?
    ) -> Double? {
        guard let checkIn else {
            return nil
        }

        let values = [
            checkIn.morningMood.map {
                Double($0.rawValue)
            },
            checkIn.eveningMood.map {
                Double($0.rawValue)
            }
        ]
        .compactMap { $0 }

        guard !values.isEmpty else {
            return nil
        }

        return values.reduce(0, +) / Double(values.count)
    }

    private func energyValue(
        from checkIn: DailyCheckIn?
    ) -> Double? {
        guard let checkIn else {
            return nil
        }

        let values = [
            checkIn.morningEnergy.map {
                Double($0.rawValue)
            },
            checkIn.eveningEnergy.map {
                Double($0.rawValue)
            }
        ]
        .compactMap { $0 }

        guard !values.isEmpty else {
            return nil
        }

        return values.reduce(0, +) / Double(values.count)
    }

    private func stressValue(
        from checkIn: DailyCheckIn?
    ) -> Double? {
        guard let checkIn else {
            return nil
        }

        let values = [
            checkIn.morningStress.map {
                Double($0.rawValue)
            },
            checkIn.eveningStress.map {
                Double($0.rawValue)
            }
        ]
        .compactMap { $0 }

        guard !values.isEmpty else {
            return nil
        }

        return values.reduce(0, +) / Double(values.count)
    }
}

enum HistoryPeriod: Int, CaseIterable, Sendable {
    case sevenDays = 7
    case thirtyDays = 30
    case ninetyDays = 90

    var title: String {
        switch self {
        case .sevenDays:
            return "7D"
        case .thirtyDays:
            return "30D"
        case .ninetyDays:
            return "90D"
        }
    }
}

struct HistoryDay: Identifiable, Sendable {
    let id = UUID()
    let date: Date
    let mood: Double?
    let energy: Double?
    let stress: Double?
    let hrv: Double?
    let restingHeartRate: Double?
    let sleepDuration: TimeInterval?
    let steps: Int?
}
