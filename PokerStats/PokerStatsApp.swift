//
//  PokerStatsApp.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import SwiftUI

@main
struct PokerStatsApp: App {
    private var storeModel = StoreModel.mockEmpty
    @ObservedObject private var navManager = NavManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                SessionsScreen()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .sessionDetails(let sessionID):
                            return SessionDetailsScreen(sessionID: sessionID)
                        }
                    }
            }.preferredColorScheme(.dark)
                .environmentObject(storeModel)
                .environmentObject(navManager)
                .environmentObject(TimerManager.shared)
        }
    }
}
