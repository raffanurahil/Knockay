import SwiftUI
import HealthKit
import UserNotifications

struct MainView: View {
    @ObservedObject var healthKitManager = HeartRateNotificationManager()
    
    var body: some View {
        VStack {
            HeartBeatAnimation(heartRate: healthKitManager.heartRate)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if !granted {
                    print("Notification permissions not granted")
                } else{
                    print("granted")
                }
            }
//            healthKitManager.sendNotification()
            //                INI YG BIKIN PER SEKIAN DETIK MUNCUL NOTIFICATION
        }
    }
}

struct HeartBeatAnimation: View {
        @State private var scale: CGFloat = 1.0
        @State private var rotation: Double = 0.0
        var heartRate: Double
        private var healthStore = HKHealthStore()
        
        @State private var isStarted: Bool = false
        @State private var isStarted2: Bool = false
        
        init(heartRate: Double) {
            self.heartRate = heartRate
        }
        
        var body: some View {
            if isStarted {
                FullScreenCoverView(isPresented: $isStarted) {
                    GameView(isStarted: $isStarted)
                }
            } else {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color(hex: "7E4040").opacity(0.8))
                        .frame(width: 250, height: 250)
                        .scaleEffect(scale)
                        .opacity(scale == 1.2 ? 0.1 : 0.5)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),value: scale)
                    
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color(hex: "7E4040").opacity(0.8))
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .opacity(scale == 1.2 ? 0.1 : 0.5)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.5), value: scale)
                    
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color(hex: "7E4040").opacity(0.8))
                        .frame(width: 150, height: 150)
                        .scaleEffect(scale)
                        .opacity(scale == 1.2 ? 0.1 : 0.5)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.0), value: scale)
                    
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color(hex: "7E4040").opacity(0.8))
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .opacity(scale == 1.2 ? 0.1 : 0.5)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.5), value: scale)
                    
                    Image("HeartImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                        .padding(.bottom, 20)
                    
                    ZStack{
                        Image("StartButtonHighlight")
                            .resizable()
                            .frame(width: 135, height: 38)
                            .rotationEffect(.degrees(rotation))
                            .animation(Animation.linear(duration: 0.25).repeatForever(autoreverses: true), value: scale)
                            .padding(.top, 130)
                            .padding(.leading, 5)
                            .onAppear {
                                startShaking()
                            }
                        //                    NavigationLink(destination: GameView(isStarted: $isStarted), label: {
                        //                        Image("StartButton")
                        //                            .resizable()
                        //                            .frame(width: 110, height: 38)
                        //                            .scaleEffect(scale)
                        //                            .padding(.top, 130)
                        //                    })
                        Button(action:{
                            isStarted2 = true
                        },label: {
                            Image("StartButton")
                                .resizable()
                                .frame(width: 110, height: 38)
                                .scaleEffect(scale)
                                .padding(.top, 130)
                        }).buttonStyle(.plain)
                        
                    }
                    VStack{
                        Text("\(Int(heartRate))").font(Font.custom("Witless", size: 30))
                        Text("BPM").font(Font.custom("Witless", size: 14))
                    }
                    .offset(x: -50,y: -90)
                    .rotationEffect(.degrees(-3.2))
                    
                }
                .onAppear {
                    self.scale = 1.2
                    requestAuthorization()
                    startHeartRateQuery()
                }
                .navigationDestination(isPresented: $isStarted2, destination: {
                    GameView(isStarted: $isStarted)
                })
            }
        }
        
        // Fungsi untuk memulai animasi shaking
        func startShaking() {
            withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
                rotation = 5 // Sudut rotasi kecil untuk efek shaking
            }
        }
        
        private func requestAuthorization() {
            let healthKitTypes: Set = [
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ]
            
            healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { success, error in
                if !success {
                    print("HealthKit authorization failed: \(String(describing: error))")
                }
            }
        }
        
        private func startHeartRateQuery() {
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [ self] _, _, error in
                if let error = error {
                    print("Observer query failed: \(error.localizedDescription)")
                    return
                }
                self.fetchLatestHeartRate()
            }
            healthStore.execute(query)
        }
        
    private func fetchLatestHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [ self] _, samples, error in
            guard let samples = samples, let sample = samples.first as? HKQuantitySample else {
                return
            }
            var weakSelf = self
            DispatchQueue.main.async {
                weakSelf.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
        healthStore.execute(query)
    }
}

#Preview{
    MainView()
}

