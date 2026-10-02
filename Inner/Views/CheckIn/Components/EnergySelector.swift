//
//  EnergySelector.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct EnergySelector: View {
    @Binding var selection: EnergyLevel?

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Energy")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(
                    EnergyLevel.allCases,
                    id: \.self
                ) { value in
                    Button {
                        selection = value
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
                            isSelected: selection == value
                        )
                    )
                }
            }
        }
    }
}

