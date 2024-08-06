//
//  SessionDetailsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import SwiftUI

struct SessionDetailsScreen: View {
    @EnvironmentObject private var storeModel: StoreModel
    @Binding var session: Session
    @State private var showBuyinsSheet = false

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
                }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showBuyinsSheet = true
                    }
            }
            
            Section("Time Played") {
                HStack {
                    Text(session.totalMinutes.toMinutes())
                      .font(.largeTitle)
                      .foregroundStyle(storeModel.isLiveSessionActive ? .green : .white)
                    Spacer()
                    if !session.isDone {
                        if storeModel.isLiveSessionActive {
                            Button("Stop") {
                                storeModel.stopTimerForLiveSession()
                            }
                        } else {
                            Button("Start") {
                                storeModel.startTimerForLiveSession()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showBuyinsSheet, onDismiss: {
            showBuyinsSheet = false
        }, content: {
            Group {
                BuyinsPageSheet(session: $session)
            }
        })
    }
}

#Preview {
    @State var storeModel = StoreModel.mockEmpty
    
    return NavigationStack {
//        SessionDetailsScreen(session: Binding(get: { storeModel.liveSession! },
//                                              set: { storeModel.liveSession = $0 }))
        SessionDetailsScreen(session: $storeModel.sessions[0])
            .environmentObject(storeModel)
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
    }
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
