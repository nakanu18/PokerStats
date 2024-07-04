//
//  SessionsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import SwiftUI

struct SessionsScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    
    var body: some View {
        List {
            Section("Info") {
                Text("Total Sessions: \(storeModel.sessions.count)")
            }
            
            Section("History") {
                ForEach(storeModel.sessions) { session in
                    NavigationLink(destination: SessionDetailsScreen(session: session)) {
                        SessionCell(session: session)
                    }
                }.onDelete { offsets in
                    storeModel.sessions.remove(atOffsets: offsets)
                }
            }
        }
        .navigationTitle("Sessions")
    }
}

#Preview {
    NavigationStack {
        SessionsScreen()
            .environmentObject(StoreModel.mockEmpty)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SessionCell: View {
    let session: Session
    
    var body: some View {
        HStack {
            Text(session.startDate.shorten())
            Spacer()
            Text(session.profit.dollars())
        }
    }
}
