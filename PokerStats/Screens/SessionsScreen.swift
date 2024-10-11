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
    
    private func newSessionView() -> some View {
        Group {
            if let liveSession = storeModel.liveSession {
                Section(header: Text("Live")) {
                    SessionCell(session: liveSession, isLive: true) {
                        NavManager.navigateToSessionDetails(sessionID: liveSession.id)
                    }
                }
            }
        }
    }
    
    private func historyView() -> some View {
        Section("History") {
            ForEach(storeModel.sessions) { session in
                SessionCell(session: session, isLive: false) {
                    NavManager.navigateToSessionDetails(sessionID: session.id)
                }
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
                LiveSessionPageSheet(favoriteTemplates: storeModel.favoriteTemplates) { templateForNewSession in
                    guard let templateForNewSession = templateForNewSession else {
                        return
                    }
                    
//                    storeModel.selectedSession = storeModel.createNewSession(template: templateForNewSession)
//                    NavManager.navigateToSessionDetails(session: storeModel.selectedSession!)
                }
            })
            .navigationDestination(for: Int.self) { sessionID in
                SessionDetailsScreen(sessionID: sessionID)
            }
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager.shared
    
    // TODO: Navigation not working in preview
    return NavigationStack(path: $navManager.path) {
        SessionsScreen()
            .navigationBarTitleDisplayMode(.inline)
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(TimerManager.shared)
}

struct SessionCell: View {
    let session: Session
    var isLive = false
    var onRowTap: (() -> Void)?

    var body: some View {
        Button {
            onRowTap?()
        } label: {
            HStack {
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
                    }
                }
                Text(session.profit.toDollars())
                Image(systemName: "chevron.right")
                    .foregroundColor(isLive ? .black : .blue)
            }
        }.foregroundColor(isLive ? .black : .white)
            .listRowBackground((isLive && !session.isDone) ? Color.green : nil)
    }
}
