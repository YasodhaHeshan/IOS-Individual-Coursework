//
//  NotificationService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import UserNotifications
import Combine
import UIKit

class NotificationService: ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var unreadCount = 0
    
    static let shared = NotificationService()
    
    private init() {}
    
    // MARK: - Request Permission
    
    func requestNotificationPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Local Notifications
    
    func sendLocalNotification(
        title: String,
        body: String,
        delay: TimeInterval = 5,
        soundName: String = ""
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = soundName.isEmpty ? .default : UNNotificationSound(named: UNNotificationSoundName(soundName))
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Notification Handling
    
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        
        if let type = userInfo["type"] as? String,
           let requestId = userInfo["requestId"] as? String {
            print("Notification handled: \(type) for request \(requestId)")
        }
    }
    
    // MARK: - Add Local Notification
    
    func addNotification(_ notification: AppNotification) {
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
            
            if !notification.read {
                self.unreadCount += 1
            }
        }
    }
    
    func markAsRead(id: String) {
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                if !self.notifications[index].read {
                    self.notifications[index].read = true
                    self.unreadCount -= 1
                }
            }
        }
    }
    
    func clearAll() {
        DispatchQueue.main.async {
            self.notifications.removeAll()
            self.unreadCount = 0
        }
    }
}

// MARK: - Notification Model

struct AppNotification: Identifiable {
    let id: String
    let title: String
    let body: String
    let type: NotificationType
    var read: Bool = false
    let createdAt: Date
    let associatedRequestId: String?
    
    enum NotificationType: String {
        case requestCreated = "request_created"
        case requestAccepted = "request_accepted"
        case requestCompleted = "request_completed"
        case garageMessage = "garage_message"
        case generalUpdate = "general_update"
    }
}
