import SwiftUI

struct ScoreGauge: View {
    @Binding var current: Double
    @State private var minValue = 0.0
    @State private var maxValue = 999.0
    
    var body: some View {
        Gauge(value: current, in: minValue...maxValue) {
            Text("BPM")
        } currentValueLabel: {
            Text("\(Int(current))")
        } minimumValueLabel: {
            Text("\(Int(minValue))")
        } maximumValueLabel: {
            Text("\(Int(maxValue))")
        }
        .gaugeStyle(SpeedometerGaugeStyle())
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [ Color(red: 207/255, green: 150/255, blue: 207/255), Color(red: 107/255, green: 116/255, blue: 179/255) ]), startPoint: .trailing, endPoint: .leading)
 
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(.darkerYellow)
                .rotationEffect(.degrees(135))
 
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(.neonYellow)
                .shadow(color: .neonYellow, radius: 10, x: 0, y: 0) // Adding glowing effect
                .rotationEffect(.degrees(135))
 
            VStack {
                Spacer()
                configuration.currentValueLabel
                    .font(Font.custom("Witless", size: 30))
                    .foregroundColor(.white)
            }
 
        }
        .frame(width: 120, height: 150)
 
    }
}

#Preview {
    ScoreGauge(current: .constant(800))
}
