//
//  GameManager.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 23/05/24.
//

import SwiftUI
import CoreMotion

class GameManager: ObservableObject {
    @Published var rageScore: Int = 0
    @Published var punchScore: Int = 0
    
    // Other game-related logic
    var totalScore: Int
    {
        print("Rage: \(rageScore), Punch: \(punchScore)")
        let squared = sqrt(Double(self.rageScore * self.punchScore))
        print("Squared: \(squared)")
        return Int(squared)
    }
}
