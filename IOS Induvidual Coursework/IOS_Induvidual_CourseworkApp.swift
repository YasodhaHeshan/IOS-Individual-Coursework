//
//  IOS_Induvidual_CourseworkApp.swift
//  IOS Induvidual Coursework
//
//  Created on 10/04/2026.
//

import SwiftUI

@main
struct IOS_Induvidual_CourseworkApp: App {
    @StateObject private var notificationService = NotificationService.shared
    @StateObject private var syncService = SyncService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    _ = await notificationService.requestNotificationPermission()
                    if syncService.lastSyncDate == nil {
                        await syncService.syncAllData()
                    }
                }
        }
    }
}
