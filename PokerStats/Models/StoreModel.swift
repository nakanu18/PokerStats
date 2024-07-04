//
//  StoreModel.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

class StoreModel: ObservableObject {
    @Published var sessions: [Session]
    
    static var mockEmpty: StoreModel {
        let mock = StoreModel()
        let session0 = Session(id: 0,
                              isDone: true,
                              startDate: Date.now,
                              totalMinutes: 105,
                              stack: [200, 300],
                              tags: ["HoldEm", "No Limit"],
                              smallBlind: 1, bigBlind: 3)
        let session1 = Session(id: 1,
                              isDone: true,
                              startDate: Date.now,
                              totalMinutes: 105,
                              stack: [300, 5],
                              tags: ["HoldEm", "No Limit"],
                              smallBlind: 1, bigBlind: 3)
        mock.sessions = [session0, session1]
        return mock
    }
    
    init() {
        sessions = []
    }
}

struct Session: Identifiable, Codable {
    let id: Int
    let isDone: Bool
    let startDate: Date
    let totalMinutes: Double
    let stack: [Double]
    
    let tags: [String] // Tag can be anything - location, gameType, limitType
    let smallBlind: Int
    let bigBlind: Int
    
    var initialBuyin: Double {
        return stack.first ?? 0
    }
    
    var totalStack: Double {
        return stack.reduce(0) { partialResult, val in
            return partialResult + val
        }
    }
    
    var totalStackInBigBlinds: Double {
        return totalStack / Double(bigBlind)
    }
    
    var profit: Double {
        return totalStack - initialBuyin
    }
}

enum GameType: Codable {
    case holdEm, omaha
}

enum LimitType: Codable {
    case limit, noLimit
}
