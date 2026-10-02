//
//  InsightMapper.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum InsightMapper {
    static func toEntity(_ model: Insight) throws -> InsightEntity {
        InsightEntity(
            id: model.id,
            type: model.type.rawValue,
            primaryMetric: model.primaryMetric.rawValue,
            relatedMetric: model.relatedMetric?.rawValue,
            patternData: try JSONEncoder().encode(model.pattern),
            sampleCount: model.sampleCount,
            strength: model.strength.rawValue,
            generatedAt: model.generatedAt,
            expiresAt: model.expiresAt,
            algorithmVersion: model.algorithmVersion
        )
    }

    static func toDomain(_ entity: InsightEntity) throws -> Insight? {
        guard
            let type = InsightType(rawValue: entity.type),
            let primaryMetric = AnalysisMetric(rawValue: entity.primaryMetric),
            let strength = PatternStrength(rawValue: entity.strength)
        else {
            return nil
        }

        let relatedMetric = entity.relatedMetric.flatMap(AnalysisMetric.init(rawValue:))
        let pattern = try JSONDecoder().decode(
            PatternResult.self,
            from: entity.patternData
        )

        return Insight(
            id: entity.id,
            type: type,
            primaryMetric: primaryMetric,
            relatedMetric: relatedMetric,
            pattern: pattern,
            sampleCount: entity.sampleCount,
            strength: strength,
            generatedAt: entity.generatedAt,
            expiresAt: entity.expiresAt,
            algorithmVersion: entity.algorithmVersion
        )
    }
}