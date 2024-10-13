//
//  NavigationManager.swift
//  PokerStats
//
//  Created by Alex de Vera on 8/15/24.
//

import SwiftUI

enum Route: Codable, Hashable {
    case sessionDetails(sessionID: Int)
}

class NavManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(route: Route) {
        print("*** Navigating to: [\(route)]")
        path.append(route)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
