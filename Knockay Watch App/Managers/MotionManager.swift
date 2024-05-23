//
//  MotionManager.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 23/05/24.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var timer: Timer?
    
    @Published var punchScore: Int = 0
    private let punchThreshold: Double = 1.5 // Adjust the threshold as needed
    
    func startUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
                if let data = self.motionManager.accelerometerData {
                    let acceleration = data.acceleration
                    let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
                    
                    if magnitude > self.punchThreshold {
                        self.punchScore += 1
                    }
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}

