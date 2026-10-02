//
//  WhatChangedSection.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct WhatChangedSection: View {
    let deviations: [MetricDeviation]

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("What Changed")
                .font(.title3.bold())

            if deviations.isEmpty {
                Text("We’re still learning what’s normal for you.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(18)
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
            } else {
                VStack(spacing: 10) {
                    ForEach(deviations) { deviation in
                        deviationRow(deviation)
                    }
                }
            }
        }
    }

    private func deviationRow(
        _ deviation: MetricDeviation
    ) -> some View {
        let metadata = MetricMetadataProvider.metadata(
            for: deviation.metric
        )

        return HStack {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(metadata.title)
                    .font(.subheadline)

                Text(
                    "\(AppFormatter.decimal(deviation.currentValue)) \(metadata.unit)"
                )
                .font(.headline)
            }

            Spacer()

            Text(statusText(deviation.status))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(
                Color(
                    .secondarySystemGroupedBackground
                )
            )
        )
    }

    private func statusText(
        _ status: DeviationStatus
    ) -> String {
        switch status {
        case .withinRange:
            return "Usual"

        case .aboveUsual:
            return "Above usual"

        case .belowUsual:
            return "Below usual"

        case .significantlyDifferent:
            return "Different"
        }
    }
}

