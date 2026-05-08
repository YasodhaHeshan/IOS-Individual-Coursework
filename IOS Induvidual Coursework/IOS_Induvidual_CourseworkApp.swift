//
//  IOS_Induvidual_CourseworkApp.swift
//  IOS Induvidual Coursework
//
//  Created on 10/04/2026.
//

import SwiftUI

@main
struct IOS_Induvidual_CourseworkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var notificationService = NotificationService.shared
    @StateObject private var syncService = SyncService.shared
    @StateObject private var accessibilitySettings = AccessibilitySettings.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Text size — scales all Dynamic Type fonts across the entire app
                .dynamicTypeSize(accessibilitySettings.dynamicTypeSize)
                // Bold text — increases font weight for all text in the app
                .environment(\.legibilityWeight, accessibilitySettings.legibilityWeight)
                // Reduce motion — disables all SwiftUI animations app-wide when on
                .transaction { t in
                    if accessibilitySettings.reduceMotionEnabled {
                        t.disablesAnimations = true
                    }
                }
                .task {
                    _ = await notificationService.requestNotificationPermission()
                    if syncService.lastSyncDate == nil {
                        await syncService.syncAllData()
                    }
                }
        }
    }
}
