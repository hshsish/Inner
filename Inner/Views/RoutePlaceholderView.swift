//
//  RoutePlaceholderView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct RoutePlaceholderView: View {
    private let title: String

    init(title: String) {
        self.title = title
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2.bold())

                Text("This screen will be implemented next.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding(20)
            .background(
                Color(.systemGroupedBackground)
            )
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}