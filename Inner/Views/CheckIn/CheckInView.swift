//
//  CheckInView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct CheckInView: View {
    private let container: AppContainer
    private let period: CheckInPeriod

    @State private var viewModel: CheckInViewModel

    init(
        period: CheckInPeriod,
        container: AppContainer
    ) {
        self.period = period
        self.container = container

        _viewModel = State(
            initialValue: CheckInViewModel(
                period: period,
                saveCheckIn: container.saveCheckIn,
                getCheckIn: container.getCheckIn,
                dateProvider: container.dateProvider
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 28
            ) {
                header

                MoodSelector(
                    selection: $viewModel.mood
                )

                EnergySelector(
                    selection: $viewModel.energy
                )

                StressSelector(
                    selection: $viewModel.stress
                )

                if period == .morning {
                    SleepQualitySelector(
                        selection: $viewModel.sleepQuality
                    )
                } else {
                    CheckInTagSelector(
                        selection: $viewModel.tags
                    )

                    NotesField(
                        text: $viewModel.notes
                    )
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                saveButton
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationTitle(
            period == .morning
                ? "Morning Check-in"
                : "Evening Check-in"
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarLeading
            ) {
                Button("Close") {
                    container.router.show(.today)
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(
                period == .morning
                    ? "Good morning"
                    : "Evening check-in"
            )
            .font(.largeTitle.bold())

            Text(
                period == .morning
                    ? "How are you feeling today?"
                    : "How was your day?"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var saveButton: some View {
        Button {
            Task {
                if await viewModel.save() {
                    container.router.show(.today)
                }
            }
        } label: {
            Group {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .buttonStyle(.borderedProminent)
        .disabled(
            !viewModel.canSave ||
            viewModel.isSaving
        )
    }
}
