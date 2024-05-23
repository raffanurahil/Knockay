//
//  ResultView.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 23/05/24.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var gameManager = GameManager()
    
    var body: some View {
        VStack {
            Text("Results")
                .font(.largeTitle)
            
            Text("Rage Score: \(gameManager.rageScore)")
            Text("Punch Score: \(gameManager.punchScore)")
            
            Button("Back to Game") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    ResultView()
}
