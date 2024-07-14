//
//  SessionDetailsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import SwiftUI

struct SessionDetailsScreen: View {
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        SessionDetailsScreen(session: Binding.constant(StoreModel.mockEmpty.sessions.first!))
            .navigationBarTitleDisplayMode(.inline)
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
