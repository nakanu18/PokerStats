//
//  SessionsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import SwiftUI

struct SessionsScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @State private var showNewSessionSheet = false
    
    var body: some View {
        List {
            Section("Info") {
                Text("Total Sessions: \(storeModel.sessions.count)")
            }
            
            Section("History") {
                ForEach(storeModel.sessions) { session in
                    let selectedSession = $storeModel.sessions[$storeModel.sessions.firstIndex(where: { $0.id == session.id })!]
                    NavigationLink(destination: SessionDetailsScreen(session: selectedSession)) {
                        SessionCell(session: session)
                    }
                }.onDelete { offsets in
                    storeModel.sessions.remove(atOffsets: offsets)
                }
            }
        }.navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("New Session") {
                        showNewSessionSheet = true
                    }
                }
            }
            .sheet(isPresented: $showNewSessionSheet, content: {
                Button("No Limit HoldEm") {
                    showNewSessionSheet = false
                }
            })
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
