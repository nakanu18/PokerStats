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
    
    static func navigateToSessionDetails(session: Session) {
        print("*** Navigating to session: [\(session.id)] - \(session.template.desc)")
        shared.path.append(session)
    }
    
    static func popToRoot() {
        shared.path.removeLast(shared.path.count)
    }
}
