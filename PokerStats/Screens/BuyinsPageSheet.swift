//
//  BuyinsPageSheet.swift
//  PokerStats
//
//  Created by Alex de Vera on 8/4/24.
//

import SwiftUI

struct BuyinsPageSheet: View {
    @Binding var session: Session

    var body: some View {
        VStack {
            List {
                ForEach(0..<session.stack.count, id: \.self) { i in
                    HStack {
                        Text("Buyin")
                        Spacer()
                        Text("\(session.stack[i].toDollars())")
                    }
                }
            }
        }
    }
}

#Preview {
    @State var storeModel = StoreModel.mockEmpty
    
    return BuyinsPageSheet(session: Binding(get: { storeModel.liveSession! },
                                            set: { storeModel.liveSession = $0 }))
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
}
