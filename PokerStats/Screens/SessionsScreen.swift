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
    @State private var isNewSessionCreated = false
    
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
            .sheet(isPresented: $showNewSessionSheet, onDismiss: {
                showNewSessionSheet = false
            }, content: {
                NewSessionView(isNewSessionCreated: $isNewSessionCreated)
            })
            .navigationDestination(isPresented: $isNewSessionCreated,
                                   destination: {
                SessionDetailsScreen(session: $storeModel.sessions[0])
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
        VStack {
            HStack {
                Text("\(session.id):")
                    .font(.caption)
                Text(session.startDate.shorten())
                    .font(.caption)
                Spacer()
            }
            HStack {
                Text("\(session.template.desc)")
                    .font(.headline)
                Spacer()
                Text(session.profit.toDollars())
            }
        }
    }
}
