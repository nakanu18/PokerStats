//
//  BuyinsPageSheet.swift
//  PokerStats
//
//  Created by Alex de Vera on 8/4/24.
//

import SwiftUI

struct BuyinsPageSheet: View {
    var session: Session

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
    @State var storeModel = StoreModel.mock()

    return BuyinsPageSheet(session: storeModel.liveSession!)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
}
