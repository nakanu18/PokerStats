//
//  StoreModel.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

class StoreModel: ObservableObject {
    @Published var sessions: [Session]
    @Published var favoriteGames: [FavoriteGame] = [
        FavoriteGame(id: 0, name: "1-2 No Limit HoldEm", smallBind: 1, bigBlind: 2, tags: [.gameType("HoldEm"), .limitType("No Limit")]),
        FavoriteGame(id: 1, name: "4-8 Limit HoldEm", smallBind: 4, bigBlind: 8, tags: [.gameType("HoldEm"), .limitType("Limit")]),
    ]
    
    static var mockEmpty: StoreModel {
        let mock = StoreModel()
        let session0 = Session(id: 0,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 200, .rebuy: 300],
                               tags: [.gameType("HoldEm"), .limitType("No Limit"), .location("Rockford")],
                               smallBlind: 1, bigBlind: 3)
        let session1 = Session(id: 1,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 300],
                               tags: [.gameType("HoldEm"), .limitType("No Limit"), .location("Horseshoe")],
                               smallBlind: 1, bigBlind: 3)
        mock.sessions = [session0, session1]
        return mock
    }
    
    init() {
        sessions = []
    }
}

enum StackEvent: Codable {
    case buyin, rebuy, adjust
}

enum Tag: Codable {
    case gameType(String), limitType(String), location(String), custom(String)
}

struct Session: Identifiable, Codable {
    let id: Int
    let isDone: Bool
    let startDate: Date
    let totalMinutes: Int
    let stack: [StackEvent: Int]
    
    let tags: [Tag]
    let smallBlind: Int
    let bigBlind: Int
    
    var initialBuyin: Int {
        return stack.first?.value ?? 0
    }
    
    var totalStack: Int {
        return stack.reduce(0) { (result, keyValue) in
            return result + keyValue.value
      }
    }
    
    var totalStackInBigBlinds: Int {
        return totalStack / bigBlind
    }
    
    var profit: Int {
        return totalStack - initialBuyin
    }
}

struct FavoriteGame: Identifiable, Codable {
    let id: Int
    let name: String
    
    let smallBind: Int
    let bigBlind: Int
    let tags: [Tag]
}
