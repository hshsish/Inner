//
//  NotesField.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct NotesField: View {
    @Binding var text: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("Anything else?")
                .font(.headline)

            TextEditor(text: $text)
                .frame(minHeight: 120)
                .padding(10)
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
    }
}
