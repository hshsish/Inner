//
//  BaselineSnapshotMapper.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum BaselineSnapshotMapper {
    static func toEntity(_ model: BaselineSnapshot) -> BaselineSnapshotEntity {
        BaselineSnapshotEntity(
            id: model.id,
            metric: model.metric.rawValue,
            median: model.median,
            mad: model.mad,
            rangeLower: model.range.lower,
            rangeUpper: model.range.upper,
            sampleCount: model.sampleCount,
            status: model.status.rawValue,
            calculationStart: model.calculationPeriod.start,
            calculationEnd: model.calculationPeriod.end,
            calculatedAt: model.calculatedAt,
            algorithmVersion: model.algorithmVersion
        )
    }

    static func toDomain(_ entity: BaselineSnapshotEntity) -> BaselineSnapshot? {
        guard
            let metric = HealthMetric(rawValue: entity.metric),
            let status = BaselineStatus(rawValue: entity.status)
        else {
            return nil
        }

        return BaselineSnapshot(
            id: entity.id,
            metric: metric,
            median: entity.median,
            mad: entity.mad,
            range: BaselineRange(
                lower: entity.rangeLower,
                upper: entity.rangeUpper
            ),
            sampleCount: entity.sampleCount,
            status: status,
            calculationPeriod: DateRange(
                start: entity.calculationStart,
                end: entity.calculationEnd
            ),
            calculatedAt: entity.calculatedAt,
            algorithmVersion: entity.algorithmVersion
        )
    }
}