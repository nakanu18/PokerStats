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
        HStack {
            Text(session.startDate.shorten())
            Spacer()
            Text(session.profit.dollars())
        }
    }
}

#Preview {
    NavigationStack {
        SessionDetailsScreen(session: Binding.constant(StoreModel.mockEmpty.sessions.first!))
            .navigationBarTitleDisplayMode(.inline)
    }
}
