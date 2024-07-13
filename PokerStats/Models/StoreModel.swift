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
        FavoriteGame(id: 0, name: "1-2 No Limit HoldEm", gameType: .holdEm, limitType: .noLimit, smallBind: 1, bigBlind: 2, tags: []),
        FavoriteGame(id: 1, name: "1-3 No Limit HoldEm", gameType: .holdEm, limitType: .noLimit, smallBind: 1, bigBlind: 3, tags: []),
        FavoriteGame(id: 2, name: "4-8 Limit HoldEm", gameType: .holdEm, limitType: .noLimit, smallBind: 4, bigBlind: 8, tags: []),
    ]
    
    static var mockEmpty: StoreModel {
        let mock = StoreModel()
        let session0 = Session(id: 1,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 200, .rebuy: 300],
                               gameType: .holdEm,
                               limitType: .noLimit,
                               tags: [.location("Rockford")],
                               smallBlind: 1, bigBlind: 3)
        let session1 = Session(id: 0,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 300],
                               gameType: .holdEm,
                               limitType: .noLimit,
                               tags: [.location("Horseshoe")],
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

enum GameType: String, Codable {
    case holdEm = "HoldEm", omaha = "Omaha"
}

enum LimitType: String, Codable {
    case noLimit = "No Limit", potLimit = "Pot Limit", limit = "Limit"
}

enum Tag: Codable {    
    case location(String), custom(String)
}

struct Session: Identifiable, Codable {
    let id: Int
    let isDone: Bool
    let startDate: Date
    let totalMinutes: Int
    let stack: [StackEvent: Int]
    
    let gameType: GameType
    let limitType: LimitType
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
    
    let gameType: GameType
    let limitType: LimitType
    let smallBind: Int
    let bigBlind: Int
    let tags: [Tag]
}
