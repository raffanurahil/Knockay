//
//  FireAnimationView.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 21/05/24.
//

import SwiftUI

struct FireDefaultView: View {
    // State to keep track of the current frame
    @State private var currentFrame = 0
    
    // Array of image names
    let fireImages = ["FireDefault1", "FireDefault2", "FireDefault3"]
    
    // Timer to update the frame
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            // Display the current frame image
            Image(fireImages[currentFrame])
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200) // Adjust the size as needed
                .onReceive(timer) { _ in
                    // Update the current frame index
                    currentFrame = (currentFrame + 1) % fireImages.count
                }
        }
    }
}

#Preview {
    FireDefaultView()

}

//struct FireAnimationView: View {
//    var body: some View {
//        FireAnimationView()
//    }
//}
//
//@main
//struct YourApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
