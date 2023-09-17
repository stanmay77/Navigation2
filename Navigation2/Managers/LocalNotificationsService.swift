import UserNotifications

final class LocalNotificationsService {
    
    let manager = UNUserNotificationCenter.current()
    static let shared = LocalNotificationsService()
    
    private init() { }
    
    func requestAuth() {
        manager.requestAuthorization(options: [.badge, .sound, .alert] ) { success, error in
            if let error {
                print(error)
            }
        }
        
    }
    
    
    func addNotification(for date: Date, under title: String, with text: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        content.sound = UNNotificationSound.default
        
        manager.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
                return
            }
            
        }
        
    }
    
    func getPendingNotifications(completion: @escaping ([Notification])->Void) {
        
        manager.getPendingNotificationRequests { requests in
            
            var notifications: [Notification] = []
            
            notifications.append(contentsOf: requests.map { request in
                var notificationTime: String = ""
                
                if let trigger = request.trigger as?
                    UNCalendarNotificationTrigger {
                    var nextDate = trigger.nextTriggerDate() ?? Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .short
                    notificationTime = dateFormatter.string(from: nextDate)
                }
                
                
                return Notification(id: request.identifier, time: notificationTime,
                                    name: request.content.title,
                                    body: request.content.body,
                                    repeats: request.trigger?.repeats ?? false)
                
            })
            completion(notifications)
        }
    }
    
    func deleteNotification(id: String) {
        manager.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    
    func checkAuthStatus(completion: @escaping (Bool)->Void) {
        manager.getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .authorized, .ephemeral, .provisional:
                completion(true)
                
            case .denied:
                completion(false)
                
            default:
                completion(true)
                
            }
        }
    }
}
