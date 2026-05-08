import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var authService = AuthService.shared
    @StateObject private var syncService = SyncService.shared

    @State private var isLoggingOut = false
    @State private var showLogoutConfirmation = false
    @State private var showTextSizePicker = false

    let textSizes = ["Small", "Default", "Large", "Extra Large"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Text("Settings")
                            .appFont(size: 18, weight: .bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Account Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ACCOUNT")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 12) {
                                    // Avatar
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.2, green: 0.2, blue: 0.3))
                                            .frame(width: 56, height: 56)
                                        
                                        Text(getInitials(viewModel.fullName))
                                            .appFont(size: 16, weight: .bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(viewModel.fullName.isEmpty ? "User" : viewModel.fullName)
                                            .appFont(size: 16, weight: .bold)
                                            .foregroundColor(.primary)
                                        
                                        Text(viewModel.email)
                                            .appFont(size: 12, weight: .regular)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: EditProfileView()) {
                                        Text("Edit\nProfile")
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.orange)
                                            .multilineTextAlignment(.trailing)
                                            .lineLimit(2)
                                    }
                                }
                                .padding(12)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - App Settings Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("APP SETTINGS")
                                    .appFont(size: 12, weight: .bold)
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
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.orange)
                                        }
                                        Text("Notifications")
                                            .appFont(size: 16, weight: .regular)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Toggle("", isOn: $viewModel.notificationsEnabled)
                                            .tint(.orange)
                                            .onChange(of: viewModel.notificationsEnabled) { _, newValue in
                                                viewModel.saveNotificationPreference(newValue)
                                            }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))

                                    Divider().padding(.horizontal, 56)

                                    // Dark Mode Toggle
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "moon.fill")
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.orange)
                                        }
                                        Text("Dark Mode")
                                            .appFont(size: 16, weight: .regular)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Toggle("", isOn: $viewModel.darkModeEnabled)
                                            .tint(.orange)
                                            .onChange(of: viewModel.darkModeEnabled) { _, newValue in
                                                viewModel.saveDarkModePreference(newValue)
                                            }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))

                                    Divider().padding(.horizontal, 56)

                                    // Language (English only)
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "globe")
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.orange)
                                        }
                                        Text("Language")
                                            .appFont(size: 16, weight: .regular)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("English")
                                            .appFont(size: 14, weight: .regular)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                }
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Accessibility Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ACCESSIBILITY")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)

                                VStack(spacing: 0) {
                                    // Text Size
                                    Button(action: { showTextSizePicker = true }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.blue.opacity(0.15))
                                                    .frame(width: 44, height: 44)
                                                Image(systemName: "textformat.size")
                                                    .appFont(size: 18, weight: .semibold)
                                                    .foregroundColor(.blue)
                                            }
                                            Text("Text Size")
                                                .appFont(size: 16, weight: .regular)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            HStack(spacing: 8) {
                                                Text(viewModel.textSize)
                                                    .appFont(size: 14)
                                                    .foregroundColor(.gray)
                                                Image(systemName: "chevron.right")
                                                    .appFont(size: 14, weight: .semibold)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    }

                                    Divider().padding(.horizontal, 56)

                                    // Bold Text
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "bold")
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.blue)
                                        }
                                        Text("Bold Text")
                                            .appFont(size: 16, weight: .regular)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Toggle("", isOn: $viewModel.boldTextEnabled)
                                            .tint(.blue)
                                            .onChange(of: viewModel.boldTextEnabled) { _, newValue in
                                                viewModel.saveBoldTextPreference(newValue)
                                            }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))

                                    Divider().padding(.horizontal, 56)

                                    // Reduce Motion
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "waveform.path.ecg")
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.blue)
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Reduce Motion")
                                                .appFont(size: 16, weight: .regular)
                                                .foregroundColor(.primary)
                                            Text("Limits animations throughout the app")
                                                .appFont(size: 11)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Toggle("", isOn: $viewModel.reduceMotionEnabled)
                                            .tint(.blue)
                                            .onChange(of: viewModel.reduceMotionEnabled) { _, newValue in
                                                viewModel.saveReduceMotionPreference(newValue)
                                            }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))

                                    Divider().padding(.horizontal, 56)

                                    // Haptic Feedback
                                    HStack(spacing: 12) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "hand.tap.fill")
                                                .appFont(size: 18, weight: .semibold)
                                                .foregroundColor(.blue)
                                        }
                                        Text("Haptic Feedback")
                                            .appFont(size: 16, weight: .regular)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Toggle("", isOn: $viewModel.hapticFeedbackEnabled)
                                            .tint(.blue)
                                            .onChange(of: viewModel.hapticFeedbackEnabled) { _, newValue in
                                                viewModel.saveHapticFeedbackPreference(newValue)
                                            }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                }
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }

                            // MARK: - Garage Management Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("GARAGE MANAGEMENT")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 20)
                                
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                            .frame(width: 56, height: 56)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.orange, lineWidth: 2)
                                            )
                                        
                                        Image(systemName: "car.fill")
                                            .appFont(size: 20, weight: .semibold)
                                            .foregroundColor(.orange)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Manage Saved Vehicles")
                                            .appFont(size: 16, weight: .bold)
                                            .foregroundColor(.primary)
                                        
                                        Text("2 Vehicles Registered")
                                            .appFont(size: 12, weight: .regular)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {}) {
                                        Image(systemName: "square.and.pencil")
                                            .appFont(size: 16, weight: .semibold)
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(12)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Support & Legal Section
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SUPPORT & LEGAL")
                                    .appFont(size: 12, weight: .bold)
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
                                                    .appFont(size: 18, weight: .semibold)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("Help Center")
                                                .appFont(size: 16, weight: .regular)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .appFont(size: 14, weight: .semibold)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
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
                                                    .appFont(size: 18, weight: .semibold)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("Contact Us")
                                                .appFont(size: 16, weight: .regular)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .appFont(size: 14, weight: .semibold)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
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
                                                    .appFont(size: 18, weight: .semibold)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Text("About RepairCost LK")
                                                .appFont(size: 16, weight: .regular)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .appFont(size: 14, weight: .semibold)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    }
                                }
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                            }
                            
                            // MARK: - Log Out Button
                            Button(action: {
                                showLogoutConfirmation = true
                            }) {
                                Text(isLoggingOut ? "Logging Out..." : "Log Out")
                                    .appFont(size: 16, weight: .semibold)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .disabled(isLoggingOut)
                            .padding(.horizontal, 20)
                            
                            // MARK: - Version Info
                            VStack(spacing: 4) {
                                Text("Version 1.0.1")
                                    .appFont(size: 12, weight: .regular)
                                    .foregroundColor(.gray)

                                Button(action: {
                                    Task {
                                        await syncService.syncAllData()
                                    }
                                }) {
                                    Text(syncService.isSyncing ? "Syncing data..." : "Sync data now")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.orange)
                                }

                                if let lastSyncDate = syncService.lastSyncDate {
                                    Text("Last sync: \(lastSyncDate.formatted(date: .abbreviated, time: .shortened))")
                                        .appFont(size: 11, weight: .regular)
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
        .onChange(of: viewModel.notificationsEnabled) { oldValue, newValue in
            // Notification preference already saved in viewModel
        }
        .alert("Log Out", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                Task {
                    await handleLogout()
                }
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .sheet(isPresented: $showTextSizePicker) {
            textSizePicker
        }
    }
    
    private var textSizePicker: some View {
        NavigationStack {
            List(textSizes, id: \.self) { size in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(size)
                            .font(textSizeFont(for: size))
                        Text("The quick brown fox")
                            .font(textSizeFont(for: size, scale: 0.75))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    if viewModel.textSize == size {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.saveTextSizePreference(size)
                    showTextSizePicker = false
                }
            }
            .navigationTitle("Text Size")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { showTextSizePicker = false }
                }
            }
        }
    }

    private func textSizeFont(for size: String, scale: CGFloat = 1.0) -> Font {
        let base: CGFloat
        switch size {
        case "Small":       base = 13
        case "Large":       base = 17
        case "Extra Large": base = 20
        default:            base = 15
        }
        return .system(size: base * scale)
    }

    private func handleLogout() async {
        isLoggingOut = true
        await authService.signOut()
        isLoggingOut = false
    }
    
    private func getInitials(_ name: String) -> String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if let first = components.first {
            return String(first.prefix(2))
        }
        return "U"
    }
}

#Preview {
    SettingsView()
}
