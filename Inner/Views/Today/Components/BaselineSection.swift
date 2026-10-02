//
//  BaselineSection.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct BaselineSection: View {
    let baselines: [HealthMetric: BaselineSnapshot]

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("Your Baseline")
                .font(.title3.bold())

            VStack(spacing: 0) {
                baselineRow(.hrv)

                Divider()

                baselineRow(.restingHeartRate)

                Divider()

                baselineRow(.sleep)
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

    private func baselineRow(
        _ metric: HealthMetric
    ) -> some View {
        let metadata = MetricMetadataProvider.metadata(
            for: metric
        )

        return HStack {
            Text(metadata.title)

            Spacer()

            if let baseline = baselines[metric] {
                Text(
                    "\(AppFormatter.decimal(baseline.range.lower))–\(AppFormatter.decimal(baseline.range.upper)) \(metadata.unit)"
                )
                .foregroundStyle(.secondary)
            } else {
                Text("Learning")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.subheadline)
        .padding(.vertical, 15)
    }
}

