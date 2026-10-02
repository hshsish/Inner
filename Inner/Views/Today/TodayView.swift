//
//  TodayView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct TodayView: View {
    private let container: AppContainer

    @State private var viewModel: TodayViewModel

    init(container: AppContainer) {
        self.container = container

        _viewModel = State(
            initialValue: TodayViewModel(
                dateProvider: container.dateProvider,
                healthRepository: container.healthRepository,
                checkInRepository: container.checkInRepository,
                baselineRepository: container.baselineRepository
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {
                    header

                    TodayStateCard(
                        state: viewModel.state
                    )

                    BaselineSection(
                        baselines: viewModel.baselines
                    )

                    WhatChangedSection(
                        deviations: viewModel.state?.deviations ?? []
                    )

                    TodayHealthSection(
                        health: viewModel.state?.health
                    )

                    CheckInButton {
                        container.router.show(
                            AppRoute.morningCheckIn
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text("Today")
                .font(.largeTitle.bold())

            Text(
                viewModel.date.formatted(
                    .dateTime
                        .weekday(.wide)
                        .month(.wide)
                        .day()
                )
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}
