//
//  StoreModel.swift
//  PokerStats
//
//  Created by Alex de Vera on 7/3/24.
//

import Foundation

class StoreModel: ObservableObject {
    @Published var sessions: [Session]
    @Published var liveSession: Session?
    @Published var selectedSession: Session?
    @Published var favoriteTemplates: [SessionTemplate] = [
        SessionTemplate(id: 0, gameType: .holdEm, limitType: .noLimit, smallBlind: 1, bigBlind: 2, maxBuyinsInBB: 100, tags: []),
        SessionTemplate(id: 1, gameType: .holdEm, limitType: .noLimit, smallBlind: 1, bigBlind: 3, maxBuyinsInBB: 100, tags: []),
        SessionTemplate(id: 2, gameType: .holdEm, limitType: .noLimit, smallBlind: 2, bigBlind: 5, maxBuyinsInBB: 100, tags: []),
        SessionTemplate(id: 10, gameType: .holdEm, limitType: .limit, smallBlind: 4, bigBlind: 8, maxBuyinsInBB: nil, tags: []),
    ]
    
    static var mockEmpty: StoreModel {
        let mock = StoreModel()
        let session0 = Session(id: 1,
                               name: "",
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [200, 300],
                               template: SessionTemplate(id: 1,
                                                         gameType: .holdEm,
                                                         limitType: .noLimit,
                                                         smallBlind: 1, 
                                                         bigBlind: 3,
                                                         maxBuyinsInBB: 100,
                                                         tags: [.location("Rockford")])
        )
        let session1 = Session(id: 0,
                               name: "",
                               isDone: true,
                               startDate: Date.now,
                               totalMinutes: 105,
                               stack: [200],
                               template: SessionTemplate(id: 1,
                                                         gameType: .holdEm,
                                                         limitType: .noLimit,
                                                         smallBlind: 1,
                                                         bigBlind: 2,
                                                         maxBuyinsInBB: 100,
                                                         tags: [.location("Horseshoe")])
        )
        mock.sessions = [session0, session1]
        mock.liveSession = mock.createNewSession(template: mock.favoriteTemplates[0])
        return mock
    }
    
    init() {
        sessions = []
    }
    
    func createNewSession(template: SessionTemplate) -> Session {
        let ID = latestSessionID + 1
        liveSession = Session(id: ID, name: "", isDone: false, startDate: Date.now, totalMinutes: 0, stack: [0], template: template)
        
        print("*** Creating new session: [\(liveSession!.id)] - \(liveSession!.template.desc)")
        return liveSession!
    }
    
    func deleteSession(sessionID: Int) {
        if let liveSession = liveSession, liveSession.id == sessionID {
            print("*** Deleting live session: [\(liveSession.id)] - \(liveSession.template.desc)")
            TimerManager.shared.stopTimer()
            self.liveSession = nil
        }
    }
    
    var latestSessionID: Int {
        guard let first = sessions.first else {
            return 0
        }
        return first.id
    }
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

struct Session: Identifiable, Codable, Hashable {
    let id: Int
    let name: String // unused
    
    let isDone: Bool
    let startDate: Date
    var totalMinutes: Float
    let stack: [Int]
    
    let template: SessionTemplate

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id
    }
    
    var initialBuyin: Int {
        return stack.first ?? 0
    }
    
    var totalBuyin: Int {
        return stack.reduce(0) { result, buyin in
            return result + buyin
        }
    }
    
    var totalStack: Int {
        return stack.reduce(0) { (result, value) in
            return result + value
        }
    }
    
    var totalStackInBigBlinds: Int {
        return totalStack / template.bigBlind
    }
    
    var profit: Int {
        return totalStack - initialBuyin
    }
    
    var profitInBigBlinds: Float {
        return Float(profit) / Float(template.bigBlind)
    }
}

struct SessionTemplate: Identifiable, Codable {
    let id: Int
    let gameType: GameType
    let limitType: LimitType
    let smallBlind: Int
    let bigBlind: Int
    let maxBuyinsInBB: Int?
    let tags: [Tag]
    
    var desc: String {
        let maxBuyin = maxBuyinsInBB != nil ? "$\(maxBuyinsInBB! * bigBlind)" : "Table Max"
        
        return "\(stakesDesc) \(gameTypeDesc) - \(maxBuyin)"
    }
    
    var gameTypeDesc: String {
        "\(limitType.rawValue) \(gameType.rawValue)"
    }
    
    var stakesDesc: String {
        "$\(smallBlind) / \(bigBlind)"
    }
}
