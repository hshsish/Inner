//
//  InsightsView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct InsightsView: View {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {
                    Text("Insights")
                        .font(.largeTitle.bold())

                    Text(
                        "Inner looks for recurring relationships in your data."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {
                        Text("We’re still learning")
                            .font(.headline)

                        Text(
                            "Keep checking in and using Apple Health. Insights will appear when there is enough personal data."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
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
                }
                .padding(20)
            }
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}