//
//  NewSessionView.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/5/24.
//

import SwiftUI

struct NewSessionView: View {
    @EnvironmentObject private var storeModel: StoreModel
    @State var selectedGame = 0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Favorites") {
                    ForEach(storeModel.favoriteGames) { fav in
                        Text("\(fav.name)")
                            .onTapGesture {
                                dismiss()
                                print("\(fav.name)")
                            }
                    }
                }
            }
            Button("Cancel") {
                dismiss()
            }
        }
    }
}

#Preview {
    return NewSessionView()
            .environmentObject(StoreModel.mockEmpty)
            .navigationBarTitleDisplayMode(.inline)
}
