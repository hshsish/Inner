//
//  AppRootView.swift
//  Inner
//
//  Created by Karina Kazbekova on 01.10.2026.
//
import SwiftUI

struct AppRootView: View {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }
    
    var body: some View {
        Group {
            switch container.router.route {
            case .morningCheckIn:
                CheckInView(
                    period: .morning,
                    container: container
                )
                
            case .eveningCheckIn:
                CheckInView(
                    period: .evening,
                    container: container
                )
                
            case .baseline(let metric):
                RoutePlaceholderView(
                    title: MetricMetadataProvider.metadata(
                        for: metric
                    ).title
                )
                
            case .day(let date):
                NavigationStack {
                    DayDetailView(
                        date: date,
                        container: container
                    )
                }
                
            default:
                MainTabView(
                    container: container
                )
            }
        }
    }
    
}
