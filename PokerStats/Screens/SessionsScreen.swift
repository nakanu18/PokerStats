//
//  SessionsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import SwiftUI

struct SessionsScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @EnvironmentObject private var navManager: NavManager
    
    @State private var showNewSessionSheet = false
    
    private func newSessionView() -> some View {
        Group {
            if let liveSession = storeModel.liveSession {
                Section(header: Text("Live")) {
                    SessionCell(session: liveSession, isLive: true) {
                        navManager.push(route: .sessionDetails(sessionID: liveSession.id))
                    }
                }
            }
        }
    }
    
    private func historyView() -> some View {
        Section("History") {
            ForEach(storeModel.sessions) { session in
                SessionCell(session: session, isLive: false) {
                    navManager.push(route: .sessionDetails(sessionID: session.id))
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
                LiveSessionPageSheet(favoriteTemplates: storeModel.favoriteTemplates) { selectedTemplate in
                    guard let selectedTemplate = selectedTemplate else {
                        return
                    }
                                        
                    let liveSession = storeModel.createNewSession(template: selectedTemplate)
                    navManager.push(route: .sessionDetails(sessionID: liveSession.id))
                }.presentationDetents([.fraction(0.85)])
            })
    }
}

#Preview {
    let storeModel = StoreModel.mock()
    @ObservedObject var navManager = NavManager()
    
    // TODO: Navigation not working in preview
    return NavigationStack(path: $navManager.path) {
        SessionsScreen()
            .navigationBarTitleDisplayMode(.inline)
    }.preferredColorScheme(.dark)
        .environmentObject(storeModel)
        .environmentObject(navManager)
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
