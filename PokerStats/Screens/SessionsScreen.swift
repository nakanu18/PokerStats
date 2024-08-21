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
                    Button {
                        storeModel.selectedSession = liveSession
                        NavManager.navigateToSessionDetails(session: liveSession)
                    } label: {
                        SessionCell(session: liveSession)
                    }.foregroundColor(.black)
                        .listRowBackground(storeModel.liveSession!.isDone ? nil : Color.green)
                }
            }
        }
    }
    
    private func historyView() -> some View {
        Section("History") {
            ForEach(storeModel.sessions) { session in
                Button {
                    storeModel.selectedSession = session
                    NavManager.navigateToSessionDetails(session: session)
                } label: {
                    SessionCell(session: session)
                }.foregroundColor(.white)
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
                        isNewSessionCreated = false
                        return
                    }
                    
                    storeModel.selectedSession = storeModel.createNewSession(template: templateForNewSession)
                    isNewSessionCreated = true
                }
            })
            .navigationDestination(for: Session.self) { _ in
                SessionDetailsScreen()
            }
            .navigationDestination(isPresented: $isNewSessionCreated,
                                   destination: {
                if storeModel.liveSession != nil {
                    SessionDetailsScreen()
                }
            })
    }
}

#Preview {
    let storeModel = StoreModel.mockEmpty
    @ObservedObject var navManager = NavManager.shared

    // Stack page sheet not working
    // Navigation not working
    return NavigationStack(path: $navManager.path) {
        SessionsScreen()
            .navigationBarTitleDisplayMode(.inline)
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        
}

struct SessionCell: View {
    let session: Session
    
    var body: some View {
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
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
    }
}
