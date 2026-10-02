//
//  DailyStateMapper.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

enum DailyStateMapper {
    static func toEntity(
        _ model: DailyState
    ) -> DailyStateEntity {
        DailyStateEntity(
            id: model.id,
            date: model.date,
            mood: model.mood,
            energy: model.energy,
            stress: model.stress,
            healthSnapshotID: model.health?.id,
            checkInID: model.checkIn?.id,
            baselineStatus: model.baselineStatus.rawValue,
            generatedAt: model.generatedAt,
            algorithmVersion: model.algorithmVersion
        )
    }

    static func update(
        _ entity: DailyStateEntity,
        from model: DailyState
    ) {
        entity.date = model.date
        entity.mood = model.mood
        entity.energy = model.energy
        entity.stress = model.stress
        entity.healthSnapshotID = model.health?.id
        entity.checkInID = model.checkIn?.id
        entity.baselineStatus = model.baselineStatus.rawValue
        entity.generatedAt = model.generatedAt
        entity.algorithmVersion = model.algorithmVersion
    }
}
