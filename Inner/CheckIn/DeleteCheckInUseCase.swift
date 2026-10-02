//
//  DeleteCheckInUseCase.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import Foundation

@MainActor
struct DeleteCheckInUseCase {
    private let repository: CheckInRepository

    init(
        repository: CheckInRepository
    ) {
        self.repository = repository
    }

    func execute(
        id: UUID
    ) async throws {
        try await repository.delete(
            id: id
        )
    }
}