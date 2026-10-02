//
//  SettingsView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//

import SwiftUI

struct SettingsView: View {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Health") {
                    Button("Apple Health") {
                    }
                }

                Section("Notifications") {
                    Button("Morning Check-in") {
                    }

                    Button("Evening Check-in") {
                    }
                }

                Section("Appearance") {
                    Button("Appearance") {
                    }
                }

                Section("Data") {
                    Button("Export Data") {
                    }

                    Button("Delete Data") {
                    }
                    .foregroundStyle(.red)
                }

                Section("About") {
                    Text("Inner")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

