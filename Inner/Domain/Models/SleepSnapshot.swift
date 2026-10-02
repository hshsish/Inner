//
//  SleepSnapshot.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

struct SleepSnapshot: Codable, Sendable, Equatable {
    let duration: TimeInterval
    let awakeDuration: TimeInterval
    let remDuration: TimeInterval
    let coreDuration: TimeInterval
    let deepDuration: TimeInterval
}
