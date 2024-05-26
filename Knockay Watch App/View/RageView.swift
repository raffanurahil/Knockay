//
//  RageView.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import SwiftUI

struct RageView: View {
    @Binding var soundLevelManager : SoundLevelManager
    
    @StateObject var soundLevelManager2 = SoundLevelManager()
    
    var body: some View {
        ZStack {
            if soundLevelManager2.rageScore > 666 {
                Fire3View()
                Fire2View()
                Fire1View()
                FireDefaultView()
            } else if soundLevelManager2.rageScore > 333 {
                Fire2View()
                Fire1View()
                FireDefaultView()
            } else if soundLevelManager2.rageScore > 10 {
                Fire1View()
                FireDefaultView()
            } else {
                FireDefaultView()
            }
            
            Image("FirePerson")
                .offset(y: 10)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 5)
            
//            VStack{
//                Text("Sound Level: \(soundLevelMonitor.soundLevel)")
//            }
            
            Spacer()
        }
        .onAppear {
            // Start monitoring sound levels
            soundLevelManager.startMonitoring()
            soundLevelManager2.startMonitoring()
        }
    }
}

#Preview {
    RageView(soundLevelManager: .constant(SoundLevelManager()))
}
