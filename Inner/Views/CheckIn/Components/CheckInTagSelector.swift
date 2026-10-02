//
//  CheckInTagSelector.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct CheckInTagSelector: View {
    @Binding var selection: [CheckInTag]

    private let tags = Array(CheckInTag.allCases)

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("What shaped your day?")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(tags, id: \.rawValue) { tag in
                    Button {
                        toggle(tag)
                    } label: {
                        Text(title(for: tag))
                            .font(.subheadline.weight(.semibold))
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 46
                            )
                    }
                    .buttonStyle(
                        SelectionButtonStyle(
                            isSelected: selection.contains(tag)
                        )
                    )
                }
            }
        }
    }

    private func toggle(
        _ tag: CheckInTag
    ) {
        if selection.contains(tag) {
            selection.removeAll {
                $0 == tag
            }
        } else {
            selection.append(tag)
        }
    }

    private func title(
        for tag: CheckInTag
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

