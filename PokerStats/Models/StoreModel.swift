//
//  StoreModel.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

class StoreModel: ObservableObject {
    @Published var sessions: [Session]
    @Published var favoriteTemplates: [SessionTemplate] = [
        SessionTemplate(id: 0, gameType: .holdEm, limitType: .noLimit, smallBlind: 1, bigBlind: 3, tags: []),
        SessionTemplate(id: 1, gameType: .holdEm, limitType: .limit, smallBlind: 4, bigBlind: 8, tags: []),
    ]
    
    static var mockEmpty: StoreModel {
        let mock = StoreModel()
        let session0 = Session(id: 1,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 200, .rebuy: 300],
                               template: SessionTemplate(id: 1,
                                                         gameType: .holdEm,
                                                         limitType: .noLimit,
                                                         smallBlind: 1, 
                                                         bigBlind: 3,
                                                         tags: [.location("Rockford")])
        )
        let session1 = Session(id: 0,
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [.buyin: 200],
                               template: SessionTemplate(id: 1,
                                                         gameType: .holdEm,
                                                         limitType: .noLimit,
                                                         smallBlind: 1,
                                                         bigBlind: 2,
                                                         tags: [.location("Horseshoe")])
        )
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
    
    let template: SessionTemplate

    var initialBuyin: Int {
        return stack.first?.value ?? 0
    }
    
    var totalStack: Int {
        return stack.reduce(0) { (result, keyValue) in
            return result + keyValue.value
        }
    }
    
    var totalStackInBigBlinds: Int {
        return totalStack / template.bigBlind
    }
    
    var profit: Int {
        return totalStack - initialBuyin
    }
}

struct SessionTemplate: Identifiable, Codable {
    let id: Int
    let gameType: GameType
    let limitType: LimitType
    let smallBlind: Int
    let bigBlind: Int
    let tags: [Tag]
    
    var name: String {
        "\(smallBlind)-\(bigBlind) \(limitType.rawValue) \(gameType.rawValue)"
    }
}
