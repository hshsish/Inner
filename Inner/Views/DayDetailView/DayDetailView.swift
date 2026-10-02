//
//  DayDetailView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct DayDetailView: View {
    private let container: AppContainer
    private let date: Date
    
    @State private var viewModel: DayDetailViewModel
    
    init(
        date: Date,
        container: AppContainer
    ) {
        self.date = date
        self.container = container
        
        _viewModel = State(
            initialValue: DayDetailViewModel(
                date: date,
                healthRepository: container.healthRepository,
                checkInRepository: container.checkInRepository,
                baselineRepository: container.baselineRepository,
                dateProvider: container.dateProvider
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                header
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(
                            maxWidth: .infinity
                        )
                } else if let state = viewModel.state {
                    TodayStateCard(
                        state: state
                    )
                    
                    WhatChangedSection(
                        deviations: state.deviations
                    )
                    
                    TodayHealthSection(
                        health: state.health
                    )
                    
                    checkInSection(
                        state.checkIn
                    )
                } else {
                    emptyState
                }
                
                if let errorMessage =
                    viewModel.errorMessage
                {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            .padding(20)
        }
        .background(
            Color(.systemGroupedBackground)
        )
        .navigationTitle(
            date.formatted(
                .dateTime
                    .month(.wide)
                    .day()
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }
    
    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            Text(
                date.formatted(
                    .dateTime
                        .weekday(.wide)
                        .month(.wide)
                        .day()
                )
            )
            .font(.largeTitle.bold())
            
            Text("Your day")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private func checkInSection(
        _ checkIn: DailyCheckIn?
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("Check-in")
                .font(.title3.bold())
            
            if let checkIn {
                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {
                    checkInRow(
                        title: "Morning",
                        mood: checkIn.morningMood,
                        energy: checkIn.morningEnergy,
                        stress: checkIn.morningStress
                    )
                    
                    Divider()
                    
                    checkInRow(
                        title: "Evening",
                        mood: checkIn.eveningMood,
                        energy: checkIn.eveningEnergy,
                        stress: checkIn.eveningStress
                    )
                    
                    if !checkIn.tags.isEmpty {
                        Divider()
                        
                        Text(
                            checkIn.tags
                                .map(tagTitle)
                                .joined(separator: " · ")
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    if let notes = checkIn.notes,
                       !notes.isEmpty {
                        Divider()
                        
                        Text(notes)
                            .font(.subheadline)
                    }
                }
                .padding(18)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
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
                Text("No check-in for this day.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func checkInRow(
        title: String,
        mood: MoodLevel?,
        energy: EnergyLevel?,
        stress: StressLevel?
    ) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            
            Spacer()
            
            Text(
                [
                    mood.map {
                        "Mood \(Double($0.rawValue))"
                    },
                    energy.map {
                        "Energy \(Double($0.rawValue))"
                    },
                    stress.map {
                        "Stress \(Double($0.rawValue))"
                    }
                ]
                    .compactMap { $0 }
                    .joined(separator: " · ")
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
    
    private var emptyState: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("No data yet")
                .font(.headline)
            
            Text(
                "There is not enough health or check-in data for this day."
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
    
    private func tagTitle(
        _ tag: CheckInTag
    ) -> String {
        switch tag {
        case .work:
            return "Work"
        case .exercise:
            return "Exercise"
        case .social:
            return "Social"
        case .relax:
            return "Relax"
        case .poorSleep:
            return "Poor sleep"
        case .other:
            return "Other"
        }
    }
    
}
