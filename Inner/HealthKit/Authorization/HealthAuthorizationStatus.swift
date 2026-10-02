//
//  HealthAuthorizationStatus.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum HealthAuthorizationStatus: Sendable {
    case notDetermined
    case authorized
    case denied
    case unavailable
}