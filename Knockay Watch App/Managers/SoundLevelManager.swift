//
//  SoundLevelManager.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import Foundation
import AVFoundation
import Combine

class SoundLevelManager: ObservableObject {
    private var audioRecorder: AVAudioRecorder!
    private var timer: Timer?
    @Published var soundLevel: Float = 0.0
    @Published var rageScore: Float = 0.0

    func startMonitoring() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let url = URL(fileURLWithPath: "/dev/null")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateSoundLevel()
            }
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func updateSoundLevel() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.audioRecorder.updateMeters()
            let level = self?.audioRecorder.averagePower(forChannel: 0) ?? -40
            DispatchQueue.main.async {
                self?.soundLevel = level
                self?.rageScore = self?.calculateRageScore(from: level) ?? 0
            }
        }
    }

    private func calculateRageScore(from soundLevel: Float) -> Float {
        // Normalisasi soundLevel dari -160 hingga 0 menjadi 0 hingga 1
        let normalizedLevel = (soundLevel + 40) / 40
        // Skalakan normalizedLevel ke rentang 0 hingga 999
        var rageScore = normalizedLevel * 999
//        print(String(rageScore))
        if rageScore < 1 {
            rageScore = 1
        }
        return rageScore
    }

    func stopMonitoring() {
        timer?.invalidate()
        audioRecorder?.stop()
    }
}
