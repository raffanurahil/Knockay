import SwiftUI

struct GameView: View {
    @Binding var isStarted: Bool
    @StateObject private var gameManager = GameManager()
    @StateObject private var motionManager = MotionManager()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showResultView = false
    
    var body: some View {
        ZStack {
            // Place the RageView at the bottom layer
            RageView()
                .offset(x: 0, y: -10)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    
                    Text("release!").font(Font.custom("Witless", size: 25))
                        .font(.headline)
                        .offset(x: 0, y: 10)
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
                
                // Add the InstructionScreamingView, InstructionArrow, and InstructionsPuncView in a horizontal row
                Image("InstructionButton")
                    .offset(x: 140, y: -10)
            }
            .padding(.horizontal)
            
            // Place the back button at the top layer
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image("BackButton")
                    .resizable()
                    .frame(width: 24, height: 24) // Adjust the image size as needed
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: -70, y: -95)
            
            if showResultView {
                NavigationLink(
                    destination: ResultView(gameManager: gameManager),
                    isActive: $showResultView,
                    label: {
                        EmptyView()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            motionManager.startUpdates()
        }
        .onDisappear {
            motionManager.stopUpdates()
        }
        .onChange(of: motionManager.punchScore) { newScore in
            gameManager.punchScore = newScore
            if newScore >= 10 { // Example threshold to trigger ResultView
                withAnimation {
                    showResultView = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameView(isStarted: .constant(true))
    }
}
