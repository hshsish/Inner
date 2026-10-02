//
//  HealthKitError.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//
import Foundation

enum HealthKitError: Error {
    case unavailable
    case authorizationDenied
    case invalidType
    case queryFailed
    case dataUnavailable
}
