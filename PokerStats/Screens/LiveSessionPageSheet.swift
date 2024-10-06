//
//  NewSessionView.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/5/24.
//

import SwiftUI

struct LiveSessionPageSheet: View {
    @Environment(\.dismiss) private var dismiss

    var favoriteTemplates: [SessionTemplate]
    var onCreateSession: (_ templateForNewSession: SessionTemplate?) -> Void

    var body: some View {
        VStack {
            List {
                Section("Favorites") {
                    ForEach(favoriteTemplates) { fav in
                        Text("\(fav.desc)")
                            .onTapGesture {
                                onCreateSession(fav)
                                dismiss()
                            }
                    }
                }
                Section("New") {
                    Button("Create New Session") {
                        // TODO: navigate to new session flow
                        onCreateSession(nil)
                        dismiss()
                    }
                }
            }
            Button("Cancel") {
                onCreateSession(nil)
                dismiss()
            }
        }
//        .navigationDestination(item: $storeModel.liveSession) { _ in
//            NewSessionScreen()
//        }
    }
}

#Preview {
    @State var storeModel = StoreModel.mockEmpty
    
    return Group {
        LiveSessionPageSheet(favoriteTemplates: storeModel.favoriteTemplates) { templateForNewSession in
            
        }.navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
    }
}
