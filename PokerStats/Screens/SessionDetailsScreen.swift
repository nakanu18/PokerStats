//
//  SessionDetailsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import SwiftUI

struct SessionDetailsScreen: View {
    @Binding var session: Session
    @State private var timer: Timer? = nil

    private func startTimer() {
        session.totalMinutes += 0.01
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var body: some View {
        List {
            Section("Date") {
                DetailCell(title: "Date", value: session.startDate.shorten())
            }
            
            Section("Overview") {
                DetailCell(title: "ID", value: "\(session.id)")
                DetailCell(title: "Game", value: session.template.desc)
                DetailCell(title: "Profit", value: session.profit.toDollars())
                DetailCell(title: "Profit in BB", value: "\(session.profitInBigBlinds.toOneDecimal()) BB")
            }
            
            Section("Time Played") {
                HStack {
                    Text(session.totalMinutes.toMinutes())
                      .font(.largeTitle)
                      .foregroundStyle(timer != nil ? .green : .white)
                    Spacer()
                    if let _ = timer {
                        Button("Stop") {
                            stopTimer()
                        }
                    } else {
                        Button("Start") {
                            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                startTimer()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @State var storeModel = StoreModel.mockEmpty
    
    return NavigationStack {
        SessionDetailsScreen(session: $storeModel.sessions.first!)
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
