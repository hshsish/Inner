//
//  CorrelationCalculator.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

struct CorrelationCalculator: Sendable {
    func pearson(
        _ lhs: [Double],
        _ rhs: [Double]
    ) -> Double? {
        guard lhs.count == rhs.count, lhs.count >= 2 else {
            return nil
        }

        let pairs = zip(lhs, rhs).filter {
            $0.0.isFinite && $0.1.isFinite
        }

        guard pairs.count >= 2 else {
            return nil
        }

        let x = pairs.map(\.0)
        let y = pairs.map(\.1)

        let meanX = x.reduce(0, +) / Double(x.count)
        let meanY = y.reduce(0, +) / Double(y.count)

        var numerator = 0.0
        var denominatorX = 0.0
        var denominatorY = 0.0

        for index in x.indices {
            let dx = x[index] - meanX
            let dy = y[index] - meanY

            numerator += dx * dy
            denominatorX += dx * dx
            denominatorY += dy * dy
        }

        guard denominatorX > 0, denominatorY > 0 else {
            return nil
        }

        return numerator / sqrt(
            denominatorX * denominatorY
        )
    }
}