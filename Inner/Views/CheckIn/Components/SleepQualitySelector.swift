//
//  SleepQualitySelector.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct SleepQualitySelector: View {
    @Binding var selection: SleepQuality?

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Sleep quality")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(SleepQuality.allCases, id: \.rawValue) { value in
                    Button {
                        selection = value
                    } label: {
                        Text(label(for: value))
                            .font(.subheadline.weight(.semibold))
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 48
                            )
                    }
                    .buttonStyle(
                        SelectionButtonStyle(
                            isSelected: selection == value
                        )
                    )
                }
            }
        }
    }

    private func label(
        for value: SleepQuality
    ) -> String {
        switch value {
        case .veryPoor:
            return "Very poor"
        case .poor:
            return "Poor"
        case .okay:
            return "Okay"
        case .good:
            return "Good"
        case .excellent:
            return "Excellent"
        }
    }
}

