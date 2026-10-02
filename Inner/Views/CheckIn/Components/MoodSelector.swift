//
//  MoodSelector.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct MoodSelector: View {
    @Binding var selection: MoodLevel?

    var body: some View {
        selector(
            title: "Mood",
            values: MoodLevel.allCases,
            selection: $selection
        )
    }

    private func selector(
        title: String,
        values: [MoodLevel],
        selection: Binding<MoodLevel?>
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text(title)
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(values, id: \.self) { value in
                    Button {
                        selection.wrappedValue = value
                    } label: {
                        Text("\(value.rawValue)")
                            .font(.headline)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 48
                            )
                    }
                    .buttonStyle(
                        SelectionButtonStyle(
                            isSelected: selection.wrappedValue == value
                        )
                    )
                }
            }
        }
    }
}
