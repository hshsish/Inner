//
//  SelectionButtonStyle.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct SelectionButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(
        configuration: Configuration
    ) -> some View {
        configuration.label
            .foregroundStyle(
                isSelected
                    ? Color.white
                    : Color.primary
            )
            .background(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
                .fill(
                    isSelected
                        ? Color.accentColor
                        : Color(
                            .secondarySystemGroupedBackground
                        )
                )
            )
            .opacity(
                configuration.isPressed
                    ? 0.7
                    : 1
            )
    }
}
