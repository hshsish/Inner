//
//  CheckInButton.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct CheckInButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Check in")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
        }
        .buttonStyle(.borderedProminent)
    }
}
