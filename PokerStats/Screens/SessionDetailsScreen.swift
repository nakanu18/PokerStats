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
            DetailCell(title: "Game Type", value: session.template.gameType.rawValue)
            DetailCell(title: "Limit", value: session.template.limitType.rawValue)
            DetailCell(title: "Date", value: session.startDate.shorten())
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
            Spacer()
            Text(value)
        }
    }
}
