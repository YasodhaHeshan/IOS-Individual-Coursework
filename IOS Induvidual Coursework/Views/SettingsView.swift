import SwiftUI

struct SettingsView: View {
    @StateObject private var notificationService = NotificationService.shared
    @StateObject private var authService = AuthService.shared
    @StateObject private var syncService = SyncService.shared

    @State private var notificationsEnabled: Bool = false
    @State private var selectedLanguage: String = "English"
    @State private var selectedUnit: String = "Metric"
    @State private var isLoggingOut = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Account Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ACCOUNT")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 12) {
                                    // Avatar
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.2, green: 0.2, blue: 0.3))
                                            .frame(width: 56, height: 56)
                                        
                                        Text("MT")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Marcus Thorne")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        Text("marcus.t@engine-precision.com")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: ProfileView(selectedTab: .constant("profile"))) {
                                        Text("Edit\nProfile")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.orange)
                                            .multilineTextAlignment(.trailing)
                                            .lineLimit(2)
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - App Settings Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("APP SETTINGS")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    // Notifications Toggle
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "bell.fill")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text("Notifications")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: $notificationsEnabled)
                                            .tint(.orange)
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    
                                    Divider()
                                        .padding(.horizontal, 56)
                                    
                                    // Privacy & Security
                                    NavigationLink(destination: Text("Privacy & Security")) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.orange.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                
                                                Image(systemName: "lock.fill")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.orange)
                                            }
                                            
                                            Text("Privacy & Security")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                    }
                                    
                                    Divider()
                                        .padding(.horizontal, 56)
                                    
                                    // Language
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "globe")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text("Language")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            Text(selectedLanguage)
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    
                                    Divider()
                                        .padding(.horizontal, 56)
                                    
                                    // Measurement Units
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "ruler.fill")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text("Measurement Units")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            Text(selectedUnit)
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(.gray)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                }
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Garage Management Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("GARAGE MANAGEMENT")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .frame(width: 56, height: 56)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.orange, lineWidth: 2)
                                            )
                                        
                                        Image(systemName: "car.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.orange)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Manage Saved Vehicles")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        Text("2 Vehicles Registered")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "square.and.pencil")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Support & Legal Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SUPPORT & LEGAL")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                VStack(spacing: 0) {
                                    // Help Center
                                    NavigationLink(destination: Text("Help Center")) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                
                                                Image(systemName: "questionmark.circle.fill")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("Help Center")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                    }
                                    
                                    Divider()
                                        .padding(.horizontal, 56)
                                    
                                    // Contact Us
                                    NavigationLink(destination: Text("Contact Us")) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                
                                                Image(systemName: "envelope.fill")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("Contact Us")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                    }
                                    
                                    Divider()
                                        .padding(.horizontal, 56)
                                    
                                    // About RepairCost LK
                                    NavigationLink(destination: Text("About RepairCost LK")) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                
                                                Image(systemName: "info.circle.fill")
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("About RepairCost LK")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                    }
                                }
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Log Out Button
                            Button(action: {
                                Task {
                                    await handleLogout()
                                }
                            }) {
                                Text(isLoggingOut ? "Logging Out..." : "Log Out")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .disabled(isLoggingOut)
                            .padding(.horizontal, 20)
                            
                            // MARK: - Version Info
                            VStack(spacing: 4) {
                                Text("Version 2.4.12 (Build 2024.102)")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)

                                Button(action: {
                                    Task {
                                        await syncService.syncAllData()
                                    }
                                }) {
                                    Text(syncService.isSyncing ? "Syncing data..." : "Sync data now")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.orange)
                                }

                                if let lastSyncDate = syncService.lastSyncDate {
                                    Text("Last sync: \(lastSyncDate.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.system(size: 11, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
                }
            }
        }
        .onChange(of: notificationsEnabled) { enabled in
            guard enabled else { return }
            Task {
                let granted = await notificationService.requestNotificationPermission()
                if !granted {
                    notificationsEnabled = false
                }
            }
        }
    }

    private func handleLogout() async {
        isLoggingOut = true
        await authService.signOut()
        isLoggingOut = false
    }
}

#Preview {
    SettingsView()
}
