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
    @Published var favoriteTemplates: [SessionTemplate] = [
        SessionTemplate(id: 0, gameType: .holdEm, limitType: .noLimit, smallBlind: 1, bigBlind: 3, tags: []),
        SessionTemplate(id: 1, gameType: .holdEm, limitType: .limit, smallBlind: 4, bigBlind: 8, tags: []),
    ]
    
    @Published private var liveSessionTimer: Timer? = nil
    
    var isLiveSessionActive: Bool {
        liveSessionTimer != nil
    }
    
    func startTimerForLiveSession() {
        stopTimerForLiveSession()
        
        guard liveSession != nil else {
            return
        }
        liveSessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.liveSession!.totalMinutes += 50/60.0;
            print("\(self.liveSession!.totalMinutes)")
        }
    }
    
    func stopTimerForLiveSession() {
        liveSessionTimer?.invalidate()
        liveSessionTimer = nil
    }

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
        mock.liveSession = mock.createNewSession(template: mock.favoriteTemplates[0])
        return mock
    }
    
    init() {
        sessions = []
    }
    
    func createNewSession(template: SessionTemplate) -> Session {
        let ID = latestSessionID + 1
        liveSession = Session(id: ID, isDone: false, startDate: Date.now, totalMinutes: 0, stack: [:], template: template)
        
        print("*** Creating new session: \(liveSession!.id) - \(liveSession!.template.desc)")
        return liveSession!
    }
    
    var latestSessionID: Int {
        guard let first = sessions.first else {
            return 0
        }
        return first.id
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
    var totalMinutes: Float
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
    let tags: [Tag]
    
    var desc: String {
        "\(stakesDesc) \(gameTypeDesc)"
    }
    
    var gameTypeDesc: String {
        "\(limitType.rawValue) \(gameType.rawValue)"
    }
    
    var stakesDesc: String {
        "$\(smallBlind) / \(bigBlind)"
    }
}
