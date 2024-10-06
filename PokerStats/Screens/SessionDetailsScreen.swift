//
//  SessionDetailsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import SwiftUI

struct SessionDetailsScreen: View {
    @EnvironmentObject private var timerManager: TimerManager
    @Environment(\.dismiss) private var dismiss
    @State private var showBuyinsSheet = false
    @Binding var session: Session

    var body: some View {
        List {
            Section("Date") {
                DetailCell(title: "Date", value: session.startDate.shorten())
            }
            
            Section("Overview") {
                DetailCell(title: "ID", value: "\(session.id)")
                DetailCell(title: "Game", value: session.template.gameTypeDesc)
                DetailCell(title: "Stakes", value: session.template.stakesDesc)
                DetailCell(title: "Profit", value: session.profit.toDollars())
                DetailCell(title: "Profit in BB", value: "\(session.profitInBigBlinds.toOneDecimal()) BB")
                HStack {
                    Text("Buyins [\(session.stack.count)]")
                    Spacer()
                    Text("\(session.totalBuyin.toDollars())")
                    Image(systemName: "chevron.down")
                        .foregroundColor(.blue)
                }.contentShape(Rectangle())
                    .onTapGesture {
                        showBuyinsSheet = true
                    }
            }
            
            Section("Time Played") {
                HStack {
                    Text(session.totalMinutes.toMinutes())
                      .font(.largeTitle)
//                      .foregroundStyle(storeModel.isLiveSessionActive ? .green : .white)
                      .foregroundStyle(.green)
                    Spacer()
                    if !session.isDone {
                        if TimerManager.shared.isRunning {
                            Button("Stop") {
                                TimerManager.shared.stopTimer()
                            }
                        } else {
                            Button("Start") {
                                TimerManager.shared.startTimer(binding: $session.totalMinutes)
                            }
                        }
                    }
                }
            }
            
            Section() {
                HStack {
                    Spacer()
                    Button("Delete Session") {
//                        storeModel.deleteSession(sessionID: session.id)
                        dismiss()
                    }.foregroundColor(.red)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showBuyinsSheet, onDismiss: {
            showBuyinsSheet = false
        }, content: {
            Group {
                BuyinsPageSheet(session: session)
            }
        })
    }
}

#Preview {
    @State var storeModel = StoreModel.mockEmpty
    storeModel.selectedSession = storeModel.liveSession
    
    return NavigationStack {
        SessionDetailsScreen(session: Binding(get: { storeModel.liveSession! },
                                              set: { newValue in storeModel.liveSession = newValue }))
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
    }.environmentObject(storeModel)
}

struct DetailCell: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
    }
}
