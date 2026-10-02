//
//  PersistenceStore.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation
import SwiftData

@MainActor
final class PersistenceStore {
    let container: ModelContainer
    let context: ModelContext

    init(inMemory: Bool = false) throws {
        let schema = Schema([
            DailyCheckInEntity.self,
            HealthSnapshotEntity.self,
            DailyStateEntity.self,
            BaselineSnapshotEntity.self,
            InsightEntity.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        container = try ModelContainer(
            for: schema,
            configurations: configuration
        )

        context = ModelContext(container)
    }
}