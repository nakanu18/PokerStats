//
//  TimerManager.swift
//  PokerStats
//
//  Created by Alex de Vera on 9/6/24.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    static let shared = TimerManager()

    @Published private var timer: Timer?
    private var binding: Binding<Float>?
    
    var isRunning: Bool {
        timer != nil
    }
    
    func startTimer(binding: Binding<Float>) {
        stopTimer()
        
        self.binding = binding
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.binding?.wrappedValue += 1/60.0
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        binding = nil
    }
}
