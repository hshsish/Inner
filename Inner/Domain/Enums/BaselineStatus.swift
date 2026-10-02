//
//  BaselineStatus.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//

import Foundation

enum BaselineStatus: String, Codable, Sendable, Equatable {
    case calibrating
    case building
    case limited
    case established
}
