//
//  RageView.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import SwiftUI

struct RageView: View {
    @StateObject private var soundLevelMonitor = SoundLevelManager()
    
    var body: some View {
        ZStack {
            if soundLevelMonitor.soundLevel > -10 {
                Fire3View()
                Fire2View()
                Fire1View()
                FireDefaultView()
            } else if soundLevelMonitor.soundLevel > -20 {
                Fire2View()
                Fire1View()
                FireDefaultView()
            } else if soundLevelMonitor.soundLevel > -30 {
                Fire1View()
                FireDefaultView()
            } else {
                FireDefaultView()
            }
            //            Fire3View()
            //            Fire2View()
            //            Fire1View()
            //            FireDefaultView()
            
            Image("FirePerson")
                .offset(y: 10)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 5)
        }
        .onAppear {
            // Start monitoring sound levels
            soundLevelMonitor.startMonitoring()
        }
    }
}

#Preview {
    RageView()
}
