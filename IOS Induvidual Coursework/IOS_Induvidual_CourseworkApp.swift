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
                .dynamicTypeSize(accessibilitySettings.dynamicTypeSize)
                .environment(\.legibilityWeight, accessibilitySettings.legibilityWeight)
                .preferredColorScheme(accessibilitySettings.darkModeEnabled ? .dark : .light)
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
