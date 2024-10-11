//
//  NavigationManager.swift
//  PokerStats
//
//  Created by Alex de Vera on 8/15/24.
//

import SwiftUI

class NavManager: ObservableObject {
    static let shared = NavManager()
    @Published var path = NavigationPath()
    
    private init() {
    }
    
    static func navigateToSessionDetails(sessionID: Int) {
        print("*** Navigating to sessionID: [\(sessionID)]")
        shared.path.append(sessionID)
    }

    static func popToRoot() {
        shared.path.removeLast(shared.path.count)
    }
}
