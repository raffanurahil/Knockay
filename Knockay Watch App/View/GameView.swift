import SwiftUI

struct GameView: View {
    @Binding var isStarted: Bool
    @StateObject private var gameManager = GameManager()
    @StateObject private var motionManager = MotionManager()
    @State var soundLevelManager = SoundLevelManager()
    @StateObject var soundLevelManager2 = SoundLevelManager()
    @State var rageSound = 0
    
    @State var result : Result = Result()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showResultView = false
    
    var body: some View {
        ZStack {
            VStack{
                
            }
            // Place the RageView at the bottom layer
            RageView(soundLevelManager: $soundLevelManager)
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
            
//            if showResultView {
//                NavigationLink(
//                    destination: ResultView(result: $result, gameManager: gameManager),
//                    isActive: $showResultView,
//                    label: {
//                        EmptyView()
//                    }
//                )
//            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            motionManager.startUpdates()
        }
        .onDisappear {
            motionManager.stopUpdates()
        }
        .onChange(of: motionManager.punchScore) { newScore in
            print(soundLevelManager.rageScore)
            print(motionManager.punchScore)
            print(newScore)
            gameManager.rageScore = Int(soundLevelManager.rageScore)
            gameManager.punchScore = newScore
            checkResult(score: gameManager.totalScore)
            if newScore >= 10 {
                motionManager.stopUpdates()
                showResultView = true
            }
        }
        .navigationDestination(isPresented: $showResultView, destination: {
            ResultView(result: $result, gameManager: gameManager)
        })
    }
    
    private func checkResult(score: Int){
        for i in 0..<resultsArray.count {
            if (score >= resultsArray[i].minScore) && (score <= resultsArray[i].maxScore) {
                result = resultsArray[i]
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameView(isStarted: .constant(true))
    }
}
