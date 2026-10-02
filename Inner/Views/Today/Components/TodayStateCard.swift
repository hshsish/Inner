//
//  TodayStateCard.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct TodayStateCard: View {
    let state: DailyState?

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 18
        ) {
            Text("Your State")
                .font(.title3.bold())

            HStack(spacing: 12) {
                StateValueCard(
                    title: "Mood",
                    value: value(
                        state?.mood
                    )
                )

                StateValueCard(
                    title: "Energy",
                    value: value(
                        state?.energy
                    )
                )

                StateValueCard(
                    title: "Stress",
                    value: value(
                        state?.stress
                    )
                )
            }
        }
    }

    private func value(
        _ value: Double?
    ) -> String {
        guard let value else {
            return "—"
        }

        return AppFormatter.decimal(
            value,
            maximumFractionDigits: 0
        )
    }
}

private struct StateValueCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2.bold())
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .background(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .fill(
                Color(
                    .secondarySystemGroupedBackground
                )
            )
        )
    }
}
