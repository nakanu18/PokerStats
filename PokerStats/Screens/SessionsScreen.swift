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

    private func newSessionView() -> some View {
        Group {
            if let liveSession = storeModel.liveSession {
                Section(header: Text("Live")) {
                    NavigationLink(destination: SessionDetailsScreen(session: Binding(get: { storeModel.liveSession! },
                                                                                      set: { storeModel.liveSession = $0 }))
                        .environmentObject(storeModel)
                    ) {
                        SessionCell(session: liveSession)
                    }.listRowBackground(liveSession.isDone ? nil : Color.green)
                }
            }
        }
    }
    
    private func historyView() -> some View {
        Section("History") {
            ForEach(storeModel.sessions) { session in
                let sessionID = storeModel.sessions.firstIndex(where: { $0.id == session.id })!
                NavigationLink(destination: SessionDetailsScreen(session: $storeModel.sessions[sessionID])
                    .environmentObject(storeModel)
                ) {
                    SessionCell(session: session)
                }.listRowBackground(session.isDone ? nil : Color.green)
            }.onDelete { offsets in
                storeModel.sessions.remove(atOffsets: offsets)
            }
        }
    }
    
    //
    // Body
    //
    
    var body: some View {
        List {
            Section("Info") {
                Text("Total Sessions: \(storeModel.sessions.count)")
            }
            newSessionView()
            historyView()
        }.navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("New Session") {
                        showNewSessionSheet = true
                    }.disabled(storeModel.liveSession != nil)
                }
            }
            .sheet(isPresented: $showNewSessionSheet, onDismiss: {
                showNewSessionSheet = false
            }, content: {
                LiveSessionView(isNewSessionCreated: $isNewSessionCreated)
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
            .preferredColorScheme(.dark)
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
