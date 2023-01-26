//Copyright © 2023 Mohammed

import UserNotifications

class TodoNotificationManager {
    
    static let shared = TodoNotificationManager()
    let center = UNUserNotificationCenter.current()
    
    private init(){}

    func scheduleNotification(for todo: TodoVM) {
        // Request permission to send notifications
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else { return }

            // Create the notification content
            let content = UNMutableNotificationContent()
            content.title = "Todo Due"
            content.body = todo.name
            content.sound = UNNotificationSound.default

            // Create a trigger that will fire in 24 hours
            let dueDate = todo.date.toDate()
            let timeInterval = max(dueDate.timeIntervalSinceNow, 0)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:timeInterval, repeats: false)

            // Create the request
            let request = UNNotificationRequest(identifier: todo.todoID, content: content, trigger: trigger)

            // Schedule the notification
            self.center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
}
