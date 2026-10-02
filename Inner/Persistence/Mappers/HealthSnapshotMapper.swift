//
//  HealthSnapshotMapper.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum HealthSnapshotMapper {
    static func toEntity(_ model: HealthSnapshot) -> HealthSnapshotEntity {
        HealthSnapshotEntity(
            id: model.id,
            date: model.date,
            heartRate: model.heartRate,
            restingHeartRate: model.restingHeartRate,
            hrv: model.hrv,
            respiratoryRate: model.respiratoryRate,
            sleepDuration: model.sleep?.duration,
            sleepAwakeDuration: model.sleep?.awakeDuration,
            sleepREM: model.sleep?.remDuration,
            sleepCore: model.sleep?.coreDuration,
            sleepDeep: model.sleep?.deepDuration,
            steps: model.steps,
            activeEnergy: model.activeEnergy,
            weight: model.weight,
            sampleDate: model.sampleDate,
            syncedAt: model.syncedAt,
            source: model.source,
            sourceIdentifier: model.sourceIdentifier
        )
    }

    static func toDomain(_ entity: HealthSnapshotEntity) -> HealthSnapshot {
        let hasSleep =
            entity.sleepDuration != nil ||
            entity.sleepAwakeDuration != nil ||
            entity.sleepREM != nil ||
            entity.sleepCore != nil ||
            entity.sleepDeep != nil

        let sleep: SleepSnapshot?

        if hasSleep {
            sleep = SleepSnapshot(
                duration: entity.sleepDuration ?? 0,
                awakeDuration: entity.sleepAwakeDuration ?? 0,
                remDuration: entity.sleepREM ?? 0,
                coreDuration: entity.sleepCore ?? 0,
                deepDuration: entity.sleepDeep ?? 0
            )
        } else {
            sleep = nil
        }

        return HealthSnapshot(
            id: entity.id,
            date: entity.date,
            heartRate: entity.heartRate,
            restingHeartRate: entity.restingHeartRate,
            hrv: entity.hrv,
            respiratoryRate: entity.respiratoryRate,
            sleep: sleep,
            steps: entity.steps,
            activeEnergy: entity.activeEnergy,
            weight: entity.weight,
            sampleDate: entity.sampleDate,
            syncedAt: entity.syncedAt,
            source: entity.source,
            sourceIdentifier: entity.sourceIdentifier
        )
    }
}