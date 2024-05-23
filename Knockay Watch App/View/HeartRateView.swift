import SwiftUI
import HealthKit

struct HeartRateView: View {
    @State private var heartRate: Double = 0.0
    private var healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            Text("Heart Rate")
                .font(.largeTitle)
                .padding()
            
            Text("\(Int(heartRate)) BPM")
                .font(.title)
                .padding()
        }
        .onAppear {
            requestAuthorization()
            startHeartRateQuery()
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
            DispatchQueue.main.async {
                self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
        healthStore.execute(query)
    }
}

//struct ContentView: View {
//    var body: some View {
//        HeartRateView()
//    }
//}
//
//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
