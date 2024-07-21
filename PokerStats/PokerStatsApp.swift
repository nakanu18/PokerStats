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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SessionsScreen()
                    .environmentObject(storeModel)
                    .navigationBarTitleDisplayMode(.inline)
            }.preferredColorScheme(.dark)
        }
    }
}
