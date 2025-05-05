//
//  NotificationManager.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-05-05.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) {success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Ready to go!")
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, date: Date, identifier: String, minutesBefore: Int = 10
    ) {
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: date) ?? date
        let components = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Scheduled for: \(components)")
            }
        }
    }
}
