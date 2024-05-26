import SwiftUI
import WatchKit

struct ResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var result: Result
    @State private var rotation: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @ObservedObject var gameManager = GameManager()
    @Environment(\.dismiss) var dismiss
    
    @State var totalScore: Double = 0.0
    
    var body: some View {

        NavigationView{
          
            ZStack {
                // Open Circle Gauge
                ScoreGauge(current: $totalScore)
                    .offset(x: 0, y: 0)
                
                // Sticker Image
                Image(result.stickerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .rotationEffect(.degrees(rotation))
                    .animation(Animation.linear(duration: 0.25).repeatForever(autoreverses: true), value: scale)
                    .onAppear {
                        startShaking()
                    }
                
                Image("MainDeck")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 120)
                    .offset(x: 0, y: -75)
                
                VStack {
                    Text(result.stickerName)
                        .offset(x: 0, y: -75)
                        .font(Font.custom("Witless", size: 24))
                }
                Button(action: {dismiss()}, label: {
                    Image("NextButton")
                        .offset(x: 60, y: 70)
                }).buttonStyle(PlainButtonStyle())
                
            }
            .onAppear {
                totalScore = Double(gameManager.totalScore)
                generateDramaticHapticFeedback()
            }
            .frame(width: 200, height: 200)
            .padding(.top,20)
        }
        
    }
    
    func startShaking() {
        withAnimation(Animation.linear(duration: 0.75).repeatForever(autoreverses: true)) {
            rotation = 5
        }
    }
    
    func generateDramaticHapticFeedback() {
        let device = WKInterfaceDevice.current()
        
        device.play(.notification) // Main notification haptic
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            device.play(.success) // Follow-up success haptic
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            device.play(.directionUp) // Another follow-up haptic
        }
    }
}

#Preview {
    ResultView(result: .constant(resultsArray[0]))
}
