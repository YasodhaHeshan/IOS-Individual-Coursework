import Foundation

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let timestamp: String
    let section: NotificationSection
    let type: NotificationType
    let actionButtonTitle: String?
    let isRead: Bool
    
    enum NotificationSection {
        case today
        case earlier
    }
    
    enum NotificationType {
        case estimateReady
        case offer
        case serviceCompleted
        case appointmentReminder
    }
}

let sampleNotifications: [Notification] = [
    Notification(
        title: "Estimate Ready",
        description: "Your repair estimate for Porsche 911 Engine Service is complete and ready for review.",
        timestamp: "2h ago",
        section: .today,
        type: .estimateReady,
        actionButtonTitle: "View Estimate",
        isRead: false
    ),
    Notification(
        title: "Precision Member Offer",
        description: "Enjoy 15% off performance brake pads with code TURBO15 at checkout.",
        timestamp: "1h ago",
        section: .today,
        type: .offer,
        actionButtonTitle: nil,
        isRead: false
    ),
    Notification(
        title: "Service Completed",
        description: "Routine oil change and multi-point inspection for BMW M4 has been finalized. Vehicle is ready for pickup.",
        timestamp: "Yesterday",
        section: .earlier,
        type: .serviceCompleted,
        actionButtonTitle: nil,
        isRead: true
    ),
    Notification(
        title: "Appointment Reminder",
        description: "Don't forget your scheduled wheel alignment tomorrow at 10:00 AM.",
        timestamp: "2d ago",
        section: .earlier,
        type: .appointmentReminder,
        actionButtonTitle: nil,
        isRead: true
    )
]
