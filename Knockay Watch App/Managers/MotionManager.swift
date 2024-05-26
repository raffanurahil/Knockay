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
    private let punchThreshold: Double = 2.5 // Adjust the threshold as needed
    var range = 0
    var check = 0
    
    func startUpdates() {
        self.punchScore = 0
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
                if let data = self.motionManager.accelerometerData {
                    let acceleration = data.acceleration
                    var magnitude = 0.0
                    
                    self.check = 0

                    if(acceleration.x < 0) && (acceleration.y > 0){
                        self.check = 1
                        magnitude = sqrt(acceleration.y * acceleration.y + acceleration.z * acceleration.z)
                        
                        let magnitude2 = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
                        
                        if(magnitude2 > self.punchThreshold){
                            self.range += 1
                        } else {
                            self.range = 0
                        }
                        
                        
                        if Int(magnitude) > self.punchScore && self.range > 2{
                            print("Magnitude: \(magnitude)")
                            print("Magnitude2: \(magnitude2)")
                            print("Range: \(self.range)")
                            print("Through: \(self.check)")
                            let normalizedLevel = magnitude / Double(self.range)
                            var normalizedMagnitude = normalizedLevel * 999
                            if normalizedMagnitude < 1 {
                                normalizedMagnitude = 1
                            }
                            self.punchScore = min(Int(normalizedMagnitude), 999)
                        }
                    }
                }
            }
        }
    }
    
    func stopUpdates() {
        self.range = 0
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}

