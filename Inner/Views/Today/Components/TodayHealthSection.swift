//
//  TodayHealthSection.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct TodayHealthSection: View {
    let health: HealthSnapshot?

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("Today’s Health")
                .font(.title3.bold())

            VStack(spacing: 0) {
                healthRow(
                    title: "Sleep",
                    value: sleepValue
                )

                Divider()

                healthRow(
                    title: "HRV",
                    value: metricValue(
                        health?.hrv,
                        unit: "ms"
                    )
                )

                Divider()

                healthRow(
                    title: "Resting HR",
                    value: metricValue(
                        health?.restingHeartRate,
                        unit: "bpm"
                    )
                )

                Divider()

                healthRow(
                    title: "Steps",
                    value: stepsValue
                )

                Divider()

                healthRow(
                    title: "Active Energy",
                    value: metricValue(
                        health?.activeEnergy,
                        unit: "kcal"
                    )
                )
            }
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(
                    cornerRadius: 22,
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

    private func healthRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.vertical, 15)
    }

    private func metricValue(
        _ value: Double?,
        unit: String
    ) -> String {
        guard let value else {
            return "—"
        }

        return "\(AppFormatter.decimal(value)) \(unit)"
    }

    private var sleepValue: String {
        guard let duration = health?.sleep?.duration else {
            return "—"
        }

        return AppFormatter.duration(duration)
    }

    private var stepsValue: String {
        guard let steps = health?.steps else {
            return "—"
        }

        return AppFormatter.integer(steps)
    }
}
