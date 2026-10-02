//
//  HistoryView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI
import Charts

struct HistoryView: View {
    private let container: AppContainer

    @State private var viewModel: HistoryViewModel

    init(container: AppContainer) {
        self.container = container

        _viewModel = State(
            initialValue: HistoryViewModel(
                healthRepository: container.healthRepository,
                checkInRepository: container.checkInRepository,
                dateProvider: container.dateProvider
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
                    periodSelector

                    if viewModel.isLoading && viewModel.days.isEmpty {
                        loadingView
                    } else if viewModel.days.isEmpty {
                        emptyView
                    } else {
                        moodSection
                        energySection
                        stressSection
                        healthSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.load()
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var periodSelector: some View {
        Picker(
            "Period",
            selection: periodBinding
        ) {
            ForEach(
                HistoryPeriod.allCases,
                id: \.self
            ) { period in
                Text(period.title)
                    .tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    private var moodSection: some View {
        metricCard(
            title: "Mood",
            description: "Your check-ins over time",
            color: .purple
        ) {
            LineChart(
                days: viewModel.days,
                value: \.mood,
                color: .purple,
                domain: 1...5
            )
        }
    }

    private var energySection: some View {
        metricCard(
            title: "Energy",
            description: "How your energy changed",
            color: .orange
        ) {
            LineChart(
                days: viewModel.days,
                value: \.energy,
                color: .orange,
                domain: 1...5
            )
        }
    }

    private var stressSection: some View {
        metricCard(
            title: "Stress",
            description: "Your reported stress level",
            color: .blue
        ) {
            LineChart(
                days: viewModel.days,
                value: \.stress,
                color: .blue,
                domain: 1...5
            )
        }
    }

    private var healthSection: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            Text("Health")
                .font(.title3.bold())

            healthMetricCard(
                title: "HRV",
                unit: "ms",
                value: average(
                    viewModel.days.compactMap(\.hrv)
                ),
                icon: "waveform.path.ecg"
            )

            healthMetricCard(
                title: "Resting Heart Rate",
                unit: "bpm",
                value: average(
                    viewModel.days.compactMap(
                        \.restingHeartRate
                    )
                ),
                icon: "heart.fill"
            )

            healthMetricCard(
                title: "Sleep",
                unit: "h",
                value: averageSleep,
                icon: "moon.fill"
            )

            healthMetricCard(
                title: "Steps",
                unit: "",
                value: average(
                    viewModel.days.compactMap {
                        $0.steps.map(Double.init)
                    }
                ),
                icon: "figure.walk"
            )
        }
    }

    private func metricCard<Content: View>(
        title: String,
        description: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            content()
                .frame(height: 150)
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

    private func healthMetricCard(
        title: String,
        unit: String,
        value: Double?,
        icon: String
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .frame(
                    width: 42,
                    height: 42
                )
                .background(
                    Circle()
                        .fill(
                            Color.accentColor.opacity(0.12)
                        )
                )

            Text(title)
                .font(.subheadline.weight(.medium))

            Spacer()

            if let value {
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 4
                ) {
                    Text(
                        formatted(
                            value,
                            title: title
                        )
                    )
                    .font(.headline.monospacedDigit())

                    if !unit.isEmpty {
                        Text(unit)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("—")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
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

    private var periodBinding: Binding<HistoryPeriod> {
        Binding(
            get: {
                viewModel.period
            },
            set: { newValue in
                Task {
                    await viewModel.select(newValue)
                }
            }
        )
    }

    private var averageSleep: Double? {
        let values = viewModel.days.compactMap {
            $0.sleepDuration.map {
                $0 / 3600
            }
        }

        return average(values)
    }

    private func average(
        _ values: [Double]
    ) -> Double? {
        guard !values.isEmpty else {
            return nil
        }

        return values.reduce(0, +) / Double(values.count)
    }

    private func formatted(
        _ value: Double,
        title: String
    ) -> String {
        switch title {
        case "Steps":
            return value.formatted(
                .number.precision(
                    .fractionLength(0)
                )
            )

        case "Sleep":
            return value.formatted(
                .number.precision(
                    .fractionLength(1)
                )
            )

        default:
            return value.formatted(
                .number.precision(
                    .fractionLength(0...1)
                )
            )
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading history…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 300
        )
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 34))
                .foregroundStyle(.secondary)

            Text("Not enough data yet")
                .font(.headline)

            Text(
                "Keep checking in and using Apple Health. Your history will appear here."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 300
        )
        .padding(20)
    }
}

private struct LineChart: View {
    let days: [HistoryDay]
    let value: (HistoryDay) -> Double?
    let color: Color
    let domain: ClosedRange<Double>

    var body: some View {
        Chart {
            ForEach(days) { day in
                if let value = value(day) {
                    LineMark(
                        x: .value(
                            "Date",
                            day.date
                        ),
                        y: .value(
                            "Value",
                            value
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(color)

                    PointMark(
                        x: .value(
                            "Date",
                            day.date
                        ),
                        y: .value(
                            "Value",
                            value
                        )
                    )
                    .foregroundStyle(color)
                }
            }
        }
        .chartYScale(domain: domain)
        .chartXAxis {
            AxisMarks(
                values: .stride(
                    by: .day,
                    count: strideCount
                )
            ) { value in
                AxisGridLine()
                    .foregroundStyle(.secondary.opacity(0.12))

                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(
                            date.formatted(
                                .dateTime.day()
                            )
                        )
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                    .foregroundStyle(.secondary.opacity(0.12))

                AxisValueLabel()
            }
        }
    }

    private var strideCount: Int {
        switch days.count {
        case 0...10:
            return 1
        case 11...31:
            return 5
        default:
            return 14
        }
    }
}
