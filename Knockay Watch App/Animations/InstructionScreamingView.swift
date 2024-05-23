//
//  InstructionsScreamingView.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import SwiftUI

struct InstructionsScreamingView: View {
    // State to keep track of the current frame
    @State private var currentFrame = 0
    // State to keep track of animation direction
    @State private var isForward = true
    
    // Array of image names
    let screamingImages = ["ScreamingInstruction1", "ScreamingInstruction2"]
    
    // Timer to update the frame
    let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            // Display the current frame image
            Image(screamingImages[currentFrame])
                .resizable()
                .scaledToFit()
                .opacity(1)
                .frame(width: 50, height: 50) // Adjust the size as needed
                .onReceive(timer) { _ in
                    // Update the current frame index based on the direction
                    if isForward {
                        currentFrame += 1
                        if currentFrame == screamingImages.count - 1 {
                            isForward = false
                        }
                    } else {
                        currentFrame -= 1
                        if currentFrame == 0 {
                            isForward = true
                        }
                    }
                }
        }
    }
}

#Preview {
    InstructionsScreamingView()
}
