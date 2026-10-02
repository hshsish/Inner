//
//  AppContainer.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

@MainActor
final class AppContainer {
    let persistenceStore: PersistenceStore

    let checkInRepository: CheckInRepository
    let healthRepository: HealthRepository
    let dailyStateRepository: DailyStateRepository
    let baselineRepository: BaselineRepository
    let insightRepository: InsightRepository

    let preferences: AppPreferences
    let router: AppRouter
    let dateProvider: AppDateProvider
    let healthKitService: HealthKitService

    let recalculationCoordinator: RecalculationCoordinator
    let dataSyncCoordinator: DataSyncCoordinator
    let backgroundSyncCoordinator: BackgroundSyncCoordinator

    let saveCheckIn: SaveCheckInUseCase
    let getCheckIn: GetCheckInUseCase
    let deleteCheckIn: DeleteCheckInUseCase

    init() {
        do {
            let store = try PersistenceStore()

            persistenceStore = store

            checkInRepository = DailyCheckInRepositoryImpl(
                context: store.context
            )

            healthRepository = HealthRepositoryImpl(
                context: store.context
            )

            dailyStateRepository = DailyStateRepositoryImpl(
                context: store.context
            )

            baselineRepository = BaselineRepositoryImpl(
                context: store.context
            )

            insightRepository = InsightRepositoryImpl(
                context: store.context
            )

            preferences = AppPreferences()
            router = AppRouter()
            dateProvider = AppDateProvider()

            healthKitService = HealthKitServiceImpl(
                dateProvider: dateProvider
            )

            recalculationCoordinator = RecalculationCoordinator(
                healthRepository: healthRepository,
                checkInRepository: checkInRepository,
                baselineRepository: baselineRepository,
                dailyStateRepository: dailyStateRepository,
                insightRepository: insightRepository
            )

            dataSyncCoordinator = DataSyncCoordinator(
                healthKitService: healthKitService,
                healthRepository: healthRepository,
                recalculationCoordinator: recalculationCoordinator,
                dateProvider: dateProvider
            )

            backgroundSyncCoordinator = BackgroundSyncCoordinator(
                dataSyncCoordinator: dataSyncCoordinator
            )

            saveCheckIn = SaveCheckInUseCase(
                repository: checkInRepository,
                dateProvider: dateProvider
            )

            getCheckIn = GetCheckInUseCase(
                repository: checkInRepository
            )

            deleteCheckIn = DeleteCheckInUseCase(
                repository: checkInRepository
            )
        } catch {
            fatalError(
                "Failed to initialize application: \(error)"
            )
        }
    }
}
