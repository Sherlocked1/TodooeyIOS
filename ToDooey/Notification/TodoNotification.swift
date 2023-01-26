//Copyright © 2023 Mohammed

import UserNotifications

class TodoNotificationManager {
    
    static let shared = TodoNotificationManager()
    let center = UNUserNotificationCenter.current()
    
    private init(){}
    
    ///adds a notification for the todo item
    func scheduleNotification(for todo: TodoVM) {
        // Request permission to send notifications
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            guard granted else { return }

            // Create the notification content
            let content = UNMutableNotificationContent()
            content.title = "Todo Due"
            content.body = todo.name
            content.sound = UNNotificationSound.default

            // Create a trigger that will fire in specified time interval
            let dueDate = todo.date.toDate()
            let timeInterval = max(dueDate.timeIntervalSinceNow, 0)
            
            //Only add notifications if the time interval is greater than 0 (now)
            if timeInterval > 0 {
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
    
    func updateTodo(_ newTodo:TodoVM){
        self.removeScheduledNotification(ForTodo: newTodo)
        self.scheduleNotification(for: newTodo)
    }
    
    ///removes the notification for the todo item
    func removeScheduledNotification(ForTodo todo:TodoVM){
        center.requestAuthorization { granted, error in
            guard granted else {return }
            if granted {
                self.center.removePendingNotificationRequests(withIdentifiers: [todo.todoID])
            }
        }
    }
    
    
    ///removes all scheduled notifications
    func removeAllScheduledNotifications(){
        self.center.removeAllDeliveredNotifications()
        self.center.removeAllPendingNotificationRequests()
    }
}
