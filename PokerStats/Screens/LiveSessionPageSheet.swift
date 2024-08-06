//
//  NewSessionView.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/5/24.
//

import SwiftUI

struct LiveSessionPageSheet: View {
    @EnvironmentObject private var storeModel: StoreModel
    @Binding var isNewSessionCreated: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack{
            List {
                Section("Favorites") {
                    ForEach(storeModel.favoriteTemplates) { fav in
                        Text("\(fav.desc)")
                            .onTapGesture {
                                let _ = storeModel.createNewSession(template: fav)
                                isNewSessionCreated = true
                                dismiss()
                            }
                    }
                }
            }
            Button("Cancel") {
                isNewSessionCreated = false
                dismiss()
            }
        }
    }
}

#Preview {
    @State var isNewSessionCreated = false
    
    return LiveSessionPageSheet(isNewSessionCreated: $isNewSessionCreated)
            .environmentObject(StoreModel.mockEmpty)
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
}
