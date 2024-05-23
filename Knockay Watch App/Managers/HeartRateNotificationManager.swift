import Foundation
import HealthKit
import UserNotifications

class HeartRateNotificationManager: NSObject, ObservableObject {
    @Published var healthStore = HKHealthStore()
    @Published var heartRate: Double = 0.0
    
    override init() {
        super.init()
        requestAuthorization()
        startHeartRateObserverQuery()
    }
    
    private func requestAuthorization() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            if !success {
                print("HealthKit authorization failed: \(String(describing: error))")
            }
        }
    }
    
    private func startHeartRateObserverQuery() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] (query, completionHandler, error) in
            guard let self = self else { return }
            self.fetchLatestHeartRate()
            completionHandler()
        }
        healthStore.execute(observerQuery)
    }
    
    private func fetchLatestHeartRate() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
            guard let self = self else { return }
            guard let sample = samples?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                let heartRateUnit = HKUnit(from: "count/min")
                self.heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                self.checkHeartRateThreshold()
            }
        }
        healthStore.execute(query)
    }
    
    private func checkHeartRateThreshold() {
        let baselineHeartRate = 60.0 // Your baseline heart rate value
        let increaseThreshold = baselineHeartRate * 1.20 // 20% increase threshold
        if heartRate >= increaseThreshold {
            sendNotification()
        }
    }
    
    public func sendNotification() {
        print("masuk")
        let content = UNMutableNotificationContent()
        content.title = "YOU SEEM ANGRY?!"
        content.body = "Control, my friend! Release your anger positively!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false))
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to send notification: \(error)")
            } else{
                print("sending notif")
            }
        }
    }
}

