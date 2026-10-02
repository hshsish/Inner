//
//  DataSyncCoordinator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

@MainActor
final class DataSyncCoordinator {
    private let healthKitService: HealthKitService
    private let healthRepository: HealthRepository
    private let recalculationCoordinator: RecalculationCoordinator
    private let dateProvider: AppDateProvider

    init(
        healthKitService: HealthKitService,
        healthRepository: HealthRepository,
        recalculationCoordinator: RecalculationCoordinator,
        dateProvider: AppDateProvider
    ) {
        self.healthKitService = healthKitService
        self.healthRepository = healthRepository
        self.recalculationCoordinator = recalculationCoordinator
        self.dateProvider = dateProvider
    }

    func syncToday() async throws {
        let today = Date()

        guard let snapshot = try await healthKitService
            .fetchLatestHealthSnapshot(for: today)
        else {
            return
        }

        try await saveOrUpdate(snapshot)

        try await recalculationCoordinator.recalculate(
            for: today,
            baselineRange: baselineRange(for: today)
        )
    }

    func syncHistory(
        days: Int = 90
    ) async throws {
        let endDate = Date()
        let startDate = dateProvider.dateByAddingDays(
            -(days - 1),
            to: dateProvider.startOfDay(for: endDate)
        )

        let range = DateRange(
            start: startDate,
            end: endDate
        )

        let snapshots = try await healthKitService
            .fetchHealthHistory(in: range)

        for snapshot in snapshots {
            try await saveOrUpdate(snapshot)
        }

        try await recalculationCoordinator.recalculate(
            for: endDate,
            baselineRange: range
        )
    }

    private func saveOrUpdate(
        _ snapshot: HealthSnapshot
    ) async throws {
        if let existing = try await healthRepository.fetch(
            for: snapshot.date
        ) {
            let updated = HealthSnapshot(
                id: existing.id,
                date: snapshot.date,
                heartRate: snapshot.heartRate,
                restingHeartRate: snapshot.restingHeartRate,
                hrv: snapshot.hrv,
                respiratoryRate: snapshot.respiratoryRate,
                sleep: snapshot.sleep,
                steps: snapshot.steps,
                activeEnergy: snapshot.activeEnergy,
                weight: snapshot.weight,
                sampleDate: snapshot.sampleDate,
                syncedAt: snapshot.syncedAt,
                source: snapshot.source,
                sourceIdentifier: snapshot.sourceIdentifier
            )

            try await healthRepository.update(updated)
        } else {
            try await healthRepository.save(snapshot)
        }
    }

    private func baselineRange(
        for date: Date
    ) -> DateRange {
        let start = dateProvider.dateByAddingDays(
            -89,
            to: dateProvider.startOfDay(for: date)
        )

        return DateRange(
            start: start,
            end: date
        )
    }
}
