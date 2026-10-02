//
//  DailyCheckInMapper.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum DailyCheckInMapper {
    static func toEntity(_ model: DailyCheckIn) -> DailyCheckInEntity {
        DailyCheckInEntity(
            id: model.id,
            date: model.date,
            morningMood: model.morningMood?.rawValue,
            morningEnergy: model.morningEnergy?.rawValue,
            morningStress: model.morningStress?.rawValue,
            subjectiveSleepQuality: model.subjectiveSleepQuality?.rawValue,
            eveningMood: model.eveningMood?.rawValue,
            eveningEnergy: model.eveningEnergy?.rawValue,
            eveningStress: model.eveningStress?.rawValue,
            tags: model.tags.map(\.rawValue),
            notes: model.notes,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }

    static func toDomain(_ entity: DailyCheckInEntity) -> DailyCheckIn {
        DailyCheckIn(
            id: entity.id,
            date: entity.date,
            morningMood: entity.morningMood.flatMap(MoodLevel.init(rawValue:)),
            morningEnergy: entity.morningEnergy.flatMap(EnergyLevel.init(rawValue:)),
            morningStress: entity.morningStress.flatMap(StressLevel.init(rawValue:)),
            subjectiveSleepQuality: entity.subjectiveSleepQuality.flatMap(SleepQuality.init(rawValue:)),
            eveningMood: entity.eveningMood.flatMap(MoodLevel.init(rawValue:)),
            eveningEnergy: entity.eveningEnergy.flatMap(EnergyLevel.init(rawValue:)),
            eveningStress: entity.eveningStress.flatMap(StressLevel.init(rawValue:)),
            tags: entity.tags.compactMap(CheckInTag.init(rawValue:)),
            notes: entity.notes,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}