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

class NotificationService: NSObject, ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var unreadCount = 0
    @Published var deviceToken: String?

    private let supabaseService = SupabaseService.shared
    private let coreDataStack = CoreDataStack.shared
    private let authService = AuthService.shared

    static let shared = NotificationService()

    private override init() {
        super.init()
    }

    func loadCachedNotifications() {
        guard let userId = authService.currentUser?.id else { return }
        let cached = coreDataStack.fetchNotifications(userId: userId)
        DispatchQueue.main.async {
            self.notifications = cached
            self.unreadCount = cached.filter { !$0.read }.count
        }
    }

    func syncNotificationsFromServer() async {
        guard let userId = authService.currentUser?.id else { return }
        if let remote = try? await supabaseService.fetchNotifications(userId: userId) {
            for n in remote { coreDataStack.saveNotification(n, userId: userId) }
            let sorted = remote.sorted { $0.createdAt > $1.createdAt }
            DispatchQueue.main.async {
                self.notifications = sorted
                self.unreadCount = sorted.filter { !$0.read }.count
            }
        }
    }

    // MARK: - Request Permission

    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            return granted
        } catch {
            print("Notification permission error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Device Token

    func storeDeviceToken(_ tokenData: Data) {
        let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
        DispatchQueue.main.async {
            self.deviceToken = token
        }
        print("APNs device token: \(token)")
    }

    // MARK: - Local Notifications

    func sendLocalNotification(
        title: String,
        body: String,
        delay: TimeInterval = 5,
        userInfo: [AnyHashable: Any] = [:],
        soundName: String = ""
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = soundName.isEmpty ? .default : UNNotificationSound(named: UNNotificationSoundName(soundName))
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.userInfo = userInfo

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Remote Notification Handling

    func handleRemoteNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: Any] else {
            completionHandler(.noData)
            return
        }

        let title: String
        let body: String

        if let alert = aps["alert"] as? [String: Any] {
            title = alert["title"] as? String ?? "Notification"
            body = alert["body"] as? String ?? ""
        } else if let alertString = aps["alert"] as? String {
            title = "Notification"
            body = alertString
        } else {
            completionHandler(.noData)
            return
        }

        let typeString = userInfo["type"] as? String ?? AppNotification.NotificationType.generalUpdate.rawValue
        let notificationType = AppNotification.NotificationType(rawValue: typeString) ?? .generalUpdate
        let requestId = userInfo["requestId"] as? String

        let notification = AppNotification(
            id: UUID().uuidString,
            title: title,
            body: body,
            type: notificationType,
            createdAt: Date(),
            associatedRequestId: requestId
        )
        addNotification(notification)
        completionHandler(.newData)
    }

    // MARK: - In-App Notification Store

    func addNotification(_ notification: AppNotification) {
        let userId = authService.currentUser?.id

        // 1. Save to CoreData immediately
        coreDataStack.saveNotification(notification, userId: userId)

        // 2. Update in-memory list
        DispatchQueue.main.async {
            self.notifications.insert(notification, at: 0)
            if !notification.read {
                self.unreadCount += 1
            }
        }

        // 3. Persist to Supabase in background (best-effort)
        if let userId {
            Task {
                try? await supabaseService.createNotification(notification, userId: userId)
            }
        }
    }

    func markAsRead(id: String) {
        // Update CoreData
        coreDataStack.markNotificationRead(id: id)

        // Update in-memory list
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                if !self.notifications[index].read {
                    self.notifications[index].read = true
                    self.unreadCount = max(0, self.unreadCount - 1)
                }
            }
        }

        // Sync to Supabase in background
        Task { try? await self.supabaseService.markNotificationRead(id: id) }
    }

    func clearAll() {
        DispatchQueue.main.async {
            self.notifications.removeAll()
            self.unreadCount = 0
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {

    // Show notifications as banners even when the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Handle taps on notifications
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let type = userInfo["type"] as? String,
           let requestId = userInfo["requestId"] as? String {
            print("Notification tapped: \(type) for request \(requestId)")
        }

        completionHandler()
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
