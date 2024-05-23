//
//  SoundLevelMonitor.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import AVFoundation

class SoundLevelMonitor: ObservableObject {
    private var audioRecorder: AVAudioRecorder!
    @Published var soundLevel: Float = 0.0

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
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.audioRecorder.updateMeters()
                self.soundLevel = self.audioRecorder.averagePower(forChannel: 0)
            }
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
}
