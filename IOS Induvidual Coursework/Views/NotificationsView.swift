import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifications = sampleNotifications
    
    var todayNotifications: [Notification] {
        notifications.filter { $0.section == .today }
    }
    
    var earlierNotifications: [Notification] {
        notifications.filter { $0.section == .earlier }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Text("Notifications")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Today Section
                        if !todayNotifications.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("TODAY")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    ForEach(todayNotifications) { notification in
                                        NotificationItemView(notification: notification)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // MARK: - Earlier Section
                        if !earlierNotifications.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("EARLIER")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    ForEach(earlierNotifications) { notification in
                                        NotificationItemView(notification: notification)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // MARK: - Partner Spotlight Section
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "wrench.and.screwdriver.fill")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                        
                                        Text("PARTNER SPOTLIGHT")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                    }
                                    
                                    Text("Upgrade Your Engine Care")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Get premium synthetic oil upgrades and ceramic coating protection from our elite partners.")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineSpacing(1.2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Text("Explore Partners")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)),
                                    Color(UIColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1))
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Notification Item View
struct NotificationItemView: View {
    let notification: Notification
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(getBackgroundColor().opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: getIconName())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(getBackgroundColor())
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(notification.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(notification.timestamp)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                Text(notification.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                    .lineSpacing(1.2)
                
                // Action Button
                if let actionButtonTitle = notification.actionButtonTitle {
                    Button(action: {}) {
                        Text(actionButtonTitle)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(12)
        .background(notification.isRead ? Color.white.opacity(0.5) : Color.white)
        .cornerRadius(10)
    }
    
    private func getIconName() -> String {
        switch notification.type {
        case .estimateReady:
            return "doc.richtext.fill"
        case .offer:
            return "tag.fill"
        case .serviceCompleted:
            return "checkmark.circle.fill"
        case .appointmentReminder:
            return "calendar"
        }
    }
    
    private func getBackgroundColor() -> Color {
        switch notification.type {
        case .estimateReady:
            return Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1))
        case .offer:
            return Color.blue
        case .serviceCompleted:
            return Color.gray
        case .appointmentReminder:
            return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
