//
//  NewSessionView.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/5/24.
//

import SwiftUI

struct NewSessionView: View {
    @EnvironmentObject private var storeModel: StoreModel
    @Binding var showNewSessionSheet: Bool
    
    var body: some View {
        List {
            ForEach(storeModel.favoriteGames) { fav in
                Text("\(fav.name)")
            }
        }
    }
}

#Preview {
    @State var showNewSessionSheet = true
    
    return NavigationStack {
        NewSessionView(showNewSessionSheet: $showNewSessionSheet)
            .environmentObject(StoreModel.mockEmpty)
    }
}
