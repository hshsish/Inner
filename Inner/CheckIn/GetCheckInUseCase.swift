//
//  GetCheckInUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

@MainActor
struct GetCheckInUseCase {
    private let repository: CheckInRepository

    init(
        repository: CheckInRepository
    ) {
        self.repository = repository
    }

    func execute(
        for date: Date
    ) async throws -> DailyCheckIn? {
        try await repository.fetch(
            for: date
        )
    }
}