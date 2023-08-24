import Foundation

import UserNotifications

class ReminderNotification {

    static func setupNotifications(deckId: Int, notificationText: String, times: [[Int]]) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "FlashcardTime"
                content.body = "Don't forget to practice your \(notificationText) flashcards."
                content.sound = UNNotificationSound.default

                var dateComponentsArray: [DateComponents] = []
                
                for array in times {
                    if array.count == 2 {
                        let hour = array[0]
                        let minute = array[1]
                        
                        var dateComponents = DateComponents()
                        dateComponents.hour = hour
                        dateComponents.minute = minute
                        
                        dateComponentsArray.append(dateComponents)
                    }
                }
                
                for (index, time) in dateComponentsArray.enumerated() {
                    let identifier = "\(deckId)_\(index)"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error adding notifications: \(error.localizedDescription)")
                        } else {
                            print("Notifications added.")
                        }
                    }
                }
            } else {
                print("Permission denied.")
            }
        }
    }

    static func removeNotifications(deckId baseKey: Int, completion: @escaping () -> Void) {
            let notificationCenter = UNUserNotificationCenter.current()
        
            notificationCenter.getPendingNotificationRequests { requests in
                let matchingRequests = requests.filter { $0.identifier.hasPrefix("\(baseKey)_") }
                
                let matchingIdentifiers = matchingRequests.map { $0.identifier }
                
                notificationCenter.removePendingNotificationRequests(withIdentifiers: matchingIdentifiers)
                
                completion()
            }
    }

    static func listNotifications(deckId baseKey: Int, completion: @escaping ([[Int]]) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { requests in
            let matchingRequests = requests.filter { $0.identifier.hasPrefix("\(baseKey)_") }
            
            var processedArray: [[Int]] = []
            
            for request in matchingRequests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let hour = trigger.dateComponents.hour ?? 0
                    let minute = trigger.dateComponents.minute ?? 0
                    processedArray.append([hour, minute])
                }
            }
            
            completion(processedArray)
            
        }
    }
}
