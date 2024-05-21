import SwiftUI

struct MainView: View {
    var body: some View {
        VStack{
            HeartBeatAnimation()
        }
    }
}

struct HeartBeatAnimation: View {
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(hex: "7E4040"))
                .opacity(0.6)
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
            
            Circle()
                .foregroundStyle(Color(hex: "7E4040"))
                .opacity(0.6)
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
            
            Image("HeartImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110) // Menyesuaikan ukuran gambar hati
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                .padding(.bottom, 20)
            
            Image("StartButtonHighlight")
                .resizable()
                .frame(width: 135, height: 38)
                .rotationEffect(.degrees(rotation))
                .animation(Animation.linear(duration: 0.25).repeatForever(autoreverses: true))
                .padding(.top, 130)
                .padding(.leading, 5)
                .onAppear {
                    startShaking()
                }
            
            Image("StartButton")
                .resizable()
                .frame(width: 110, height: 38)
                .scaleEffect(scale)
                .padding(.top, 130)
            
        }
        .onAppear {
            self.scale = 1.2
        }
    }
    
    // Fungsi untuk memulai animasi shaking
    func startShaking() {
        withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
            rotation = 5 // Sudut rotasi kecil untuk efek shaking
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
