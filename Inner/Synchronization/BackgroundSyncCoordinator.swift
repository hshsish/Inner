//
//  BackgroundSyncCoordinator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//
import Foundation
import BackgroundTasks
import os

@MainActor
final class BackgroundSyncCoordinator {
    static let taskIdentifier = "fobos.Inner.health-sync"

    private let dataSyncCoordinator: DataSyncCoordinator

    init(
        dataSyncCoordinator: DataSyncCoordinator
    ) {
        self.dataSyncCoordinator = dataSyncCoordinator
    }

    func register() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.taskIdentifier,
            using: nil
        ) { [weak self] task in
            guard let task = task as? BGAppRefreshTask else {
                return
            }

            Task { @MainActor [weak self] in
                await self?.handle(task)
            }
        }
    }

    func schedule() {
        let request = BGAppRefreshTaskRequest(
            identifier: Self.taskIdentifier
        )

        request.earliestBeginDate = Date(
            timeIntervalSinceNow: 60 * 60
        )

        do {
            try BGTaskScheduler.shared.submit(
                request
            )
        } catch {
            AppLogger.sync.error(
                "Failed to schedule background sync: \(error.localizedDescription)"
            )
        }
    }

    private func handle(
        _ task: BGAppRefreshTask
    ) async {
        schedule()

        do {
            try await dataSyncCoordinator.syncToday()

            task.setTaskCompleted(
                success: true
            )
        } catch {
            AppLogger.sync.error(
                "Background sync failed: \(error.localizedDescription)"
            )

            task.setTaskCompleted(
                success: false
            )
        }
    }
}
