//
//  SessionDetailsScreen.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/4/24.
//

import SwiftUI

struct SessionDetailsScreen: View {
    let session: Session
    
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
        SessionDetailsScreen(session: StoreModel.mockEmpty.sessions.first!)
            .navigationBarTitleDisplayMode(.inline)
    }
}
