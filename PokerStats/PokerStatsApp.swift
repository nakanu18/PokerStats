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
    @ObservedObject private var navManager = NavManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                SessionsScreen()
                    .navigationBarTitleDisplayMode(.inline)
            }.preferredColorScheme(.dark)
                .environmentObject(storeModel)
                .environmentObject(TimerManager.shared)
        }
    }
}
