//
//  InnerApp.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import SwiftUI
import os

@main
struct InnerApp: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView(
                container: container
            )
            .task {
                await startApplication()
            }
        }
    }

    private func startApplication() async {
        container.backgroundSyncCoordinator.register()

        do {
            if !container.preferences.healthKitRequested {
                try await container.healthKitService
                    .requestAuthorization()

                container.preferences.healthKitRequested = true
            }

            try await container.dataSyncCoordinator.syncHistory(
                days: 90
            )

            container.backgroundSyncCoordinator.schedule()
        } catch {
            AppLogger.sync.error(
                "Application sync failed: \(error.localizedDescription)"
            )
        }
    }
}
