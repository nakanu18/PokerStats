//
//  NavigationManager.swift
//  PokerStats
//
//  Created by Alex de Vera on 8/15/24.
//

import SwiftUI

// Change this from singleton to EnvironmentObject
// Move the .destinations to main app or to here as a view modifier(?)
class NavManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateToSessionDetails(sessionID: Int) {
        print("*** Navigating to sessionID: [\(sessionID)]")
        path.append(sessionID)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
