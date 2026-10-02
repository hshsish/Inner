//
//  MainTabView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//


import SwiftUI

struct MainTabView: View {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    var body: some View {
        TabView(
            selection: tabSelection
        ) {
            TodayView(
                container: container
            )
            .tabItem {
                Label(
                    "Today",
                    systemImage: "house"
                )
            }
            .tag(AppRoute.today)

            HistoryView(
                container: container
            )
            .tabItem {
                Label(
                    "History",
                    systemImage: "chart.xyaxis.line"
                )
            }
            .tag(AppRoute.history)

            InsightsView(
                container: container
            )
            .tabItem {
                Label(
                    "Insights",
                    systemImage: "lightbulb"
                )
            }
            .tag(AppRoute.insights)

            SettingsView(
                container: container
            )
            .tabItem {
                Label(
                    "Settings",
                    systemImage: "gearshape"
                )
            }
            .tag(AppRoute.settings)
        }
    }

    private var tabSelection: Binding<AppRoute> {
        Binding(
            get: {
                container.router.route
            },
            set: {
                container.router.show($0)
            }
        )
    }
}
