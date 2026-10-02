//
//  HealthKitServiceImpl.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation
import HealthKit

final class HealthKitServiceImpl: HealthKitService, @unchecked Sendable {
    private let authorizationManager: HealthKitAuthorizationManager
    private let quantityQueryService: QuantityQueryService
    private let sleepQueryService: SleepQueryService
    private let aggregator: HealthKitAggregator
    private let sleepProcessor: SleepProcessor
    private let dateProvider: AppDateProvider

    init(
        healthStore: HKHealthStore = HKHealthStore(),
        dateProvider: AppDateProvider = AppDateProvider()
    ) {
        self.dateProvider = dateProvider

        authorizationManager = HealthKitAuthorizationManager(
            healthStore: healthStore
        )

        quantityQueryService = QuantityQueryService(
            healthStore: healthStore
        )

        sleepQueryService = SleepQueryService(
            healthStore: healthStore
        )

        aggregator = HealthKitAggregator()
        sleepProcessor = SleepProcessor()
    }

    func requestAuthorization() async throws {
        try await authorizationManager.requestAuthorization()
    }

    func fetchLatestHealthSnapshot(
        for date: Date
    ) async throws -> HealthSnapshot? {
        let startDate = dateProvider.startOfDay(
            for: date
        )

        let endDate = dateProvider.endOfDay(
            for: date
        )

        return try await fetchSnapshot(
            date: date,
            startDate: startDate,
            endDate: endDate
        )
    }

    func fetchHealthHistory(
        in range: DateRange
    ) async throws -> [HealthSnapshot] {
        let startDate = range.start
        let endDate = range.end

        var snapshots: [HealthSnapshot] = []

        var currentDate = dateProvider.startOfDay(
            for: startDate
        )

        while currentDate <= endDate {
            if let snapshot = try await fetchSnapshot(
                date: currentDate,
                startDate: dateProvider.startOfDay(
                    for: currentDate
                ),
                endDate: dateProvider.endOfDay(
                    for: currentDate
                )
            ) {
                snapshots.append(snapshot)
            }

            currentDate = dateProvider.dateByAddingDays(
                1,
                to: currentDate
            )
        }

        return snapshots
    }

    func startMonitoring() async throws {
    }

    func stopMonitoring() async {
    }

    private func fetchSnapshot(
        date: Date,
        startDate: Date,
        endDate: Date
    ) async throws -> HealthSnapshot? {
        let heartRate = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.heartRate,
            startDate: startDate,
            endDate: endDate
        )

        let restingHeartRate = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.restingHeartRate,
            startDate: startDate,
            endDate: endDate
        )

        let hrv = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.heartRateVariability,
            startDate: startDate,
            endDate: endDate
        )

        let respiratory = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.respiratoryRate,
            startDate: startDate,
            endDate: endDate
        )

        let stepSamples = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.stepCount,
            startDate: startDate,
            endDate: endDate
        )

        let energySamples = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.activeEnergyBurned,
            startDate: startDate,
            endDate: endDate
        )

        let weightSamples = try await quantityQueryService.samples(
            type: HealthKitTypeProvider.bodyMass,
            startDate: startDate,
            endDate: endDate
        )

        let sleep = try await sleepQueryService.samples(
            startDate: startDate,
            endDate: endDate
        )

        let heartRateValues = heartRate.map {
            $0.quantity.doubleValue(
                for: HKUnit.count().unitDivided(
                    by: HKUnit.minute()
                )
            )
        }

        let restingHeartRateValues = restingHeartRate.map {
            $0.quantity.doubleValue(
                for: HKUnit.count().unitDivided(
                    by: HKUnit.minute()
                )
            )
        }

        let hrvValues = hrv.map {
            $0.quantity.doubleValue(
                for: HKUnit.secondUnit(
                    with: .milli
                )
            )
        }

        let respiratoryValues = respiratory.map {
            $0.quantity.doubleValue(
                for: HKUnit.count().unitDivided(
                    by: HKUnit.minute()
                )
            )
        }

        let stepValue = aggregator.sum(
            stepSamples,
            unit: HKUnit.count()
        )

        let energyValue = aggregator.sum(
            energySamples,
            unit: HKUnit.kilocalorie()
        )

        let weightSample = aggregator.latest(
            weightSamples
        )

        let weightValue = weightSample?.quantity.doubleValue(
            for: HKUnit.gramUnit(
                with: .kilo
            )
        )

        let sleepSnapshot = sleepProcessor.process(
            samples: sleep
        )

        let latestSamples = [
            aggregator.latest(heartRate),
            aggregator.latest(restingHeartRate),
            aggregator.latest(hrv),
            aggregator.latest(respiratory),
            aggregator.latest(weightSamples)
        ]
        .compactMap { $0 }

        let latestSampleDate = latestSamples
            .map(\.endDate)
            .max()

        let source = latestSamples
            .first?
            .sourceRevision
            .source
            .name

        let sourceIdentifier = latestSamples
            .first?
            .uuid
            .uuidString

        let hasData =
            !heartRateValues.isEmpty ||
            !restingHeartRateValues.isEmpty ||
            !hrvValues.isEmpty ||
            !respiratoryValues.isEmpty ||
            !stepSamples.isEmpty ||
            !energySamples.isEmpty ||
            !weightSamples.isEmpty ||
            sleepSnapshot != nil

        guard hasData else {
            return nil
        }

        return HealthSnapshot(
            id: UUID(),
            date: date,
            heartRate: aggregator.median(
                heartRateValues
            ),
            restingHeartRate: aggregator.median(
                restingHeartRateValues
            ),
            hrv: aggregator.median(
                hrvValues
            ),
            respiratoryRate: aggregator.median(
                respiratoryValues
            ),
            sleep: sleepSnapshot,
            steps: stepSamples.isEmpty
                ? nil
                : Int(
                    stepValue.rounded()
                ),
            activeEnergy: energySamples.isEmpty
                ? nil
                : energyValue,
            weight: weightValue,
            sampleDate: latestSampleDate,
            syncedAt: Date(),
            source: source,
            sourceIdentifier: sourceIdentifier
        )
    }
}
