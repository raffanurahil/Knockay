import SwiftUI

struct GameView: View {
    @Binding var isStarted: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Place the RageView at the bottom layer
            RageView()
                .offset(x: 0, y: -30)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    
                    Text("release!").font(Font.custom("Witless", size: 25))
                        .font(.headline)
                        .offset(x: 0, y: 5)
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
                
                // Add the InstructionScreamingView, InstructionArrow, and InstructionsPuncView in a horizontal row
                HStack {
                    InstructionsScreamingView()
                        .offset(x: 15, y: 15)
                    
                    Image("InstructionArrow")
                        .offset(x: 15, y: 17.5)
                    
                    InstructionsPunchView()
                        .offset(x: 25, y: 20)
                }
                .padding(.bottom)
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
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        GameView(isStarted: .constant(true))
    }
}
