import SwiftUI

struct ProfileView: View {
    @Binding var selectedTab: String
    @StateObject private var authService = AuthService.shared
    @StateObject private var repairRequestService = RepairRequestService.shared
    @StateObject private var syncService = SyncService.shared
    
    private var userName: String {
        authService.currentUser?.fullName
            ?? authService.currentUser?.email.components(separatedBy: "@").first?.capitalized
            ?? "Guest User"
    }

    private var userSubtitle: String {
        authService.currentUser?.email ?? "Sign in to sync your history"
    }

    private var userInitials: String {
        let name = authService.currentUser?.fullName
            ?? authService.currentUser?.email.components(separatedBy: "@").first
            ?? "U"
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return (String(parts[0].prefix(1)) + String(parts[1].prefix(1))).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    private var estimateHistory: [(number: String, name: String, price: String, status: String)] {
        let mapped = repairRequestService.repairRequests.prefix(3).enumerated().map { index, request in
            let estimated = Int(request.predictedCost ?? 0)
            return (
                number: String(format: "%02d", index + 1),
                name: request.damageCategory.isEmpty ? request.description : request.damageCategory,
                price: estimated > 0 ? "LKR \(estimated)" : "Pending",
                status: request.status.capitalized
            )
        }

        if !mapped.isEmpty {
            return mapped
        }

        return [
            (number: "01", name: "Bumper Repair", price: "LKR 45,000", status: "Urgent Fix"),
            (number: "05", name: "Engine Tune-up", price: "LKR 12,000", status: "Urgent"),
            (number: "28", name: "Brake Pad Change", price: "LKR 8,500", status: "Completed")
        ]
    }
    
    private var profileInitialsView: some View {
        ZStack {
            Circle()
                .fill(Color(UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1)))
                .frame(width: 80, height: 80)
            Text(userInitials)
                .appFont(size: 28, weight: .bold)
                .foregroundColor(.orange)
        }
    }

    let savedVehicles = [
        (name: "Toyota Prius", services: "3 car services"),
        (name: "Honda Hornet", services: "2 car services")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Text("Profile")
                        .appFont(size: 18, weight: .bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .appFont(size: 16, weight: .semibold)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Profile Section
                        VStack(spacing: 12) {
                            // Avatar
                            ZStack {
                                if let urlString = authService.currentUser?.profileImageURL,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        default:
                                            profileInitialsView
                                        }
                                    }
                                } else {
                                    profileInitialsView
                                }
                            }
                            
                            Text(userName)
                                .appFont(size: 20, weight: .bold)
                                .foregroundColor(.primary)
                            
                            Text(userSubtitle)
                                .appFont(size: 12, weight: .regular)
                                .foregroundColor(.gray)
                            
                            // Stats
                            HStack(spacing: 24) {
                                VStack(spacing: 4) {
                                    Text("\(max(0, repairRequestService.repairRequests.count))")
                                        .appFont(size: 16, weight: .bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("REQUESTS")
                                        .appFont(size: 10, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(spacing: 4) {
                                    Text(syncService.lastSyncDate == nil ? "-" : "OK")
                                        .appFont(size: 16, weight: .bold)
                                        .foregroundColor(.orange)
                                    
                                    Text("SYNC")
                                        .appFont(size: 10, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // MARK: - Saved Vehicles Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("SAVED VEHICLES")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                NavigationLink(destination: SelectVehicleView()) {
                                    Text("VIEW ALL")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(savedVehicles, id: \.name) { vehicle in
                                    HStack(spacing: 12) {
                                        Image(systemName: "car.fill")
                                            .appFont(size: 20, weight: .semibold)
                                            .foregroundColor(.orange)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(vehicle.name)
                                                .appFont(size: 14, weight: .semibold)
                                                .foregroundColor(.primary)
                                            
                                            Text(vehicle.services)
                                                .appFont(size: 11, weight: .regular)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                                
                                // Add Vehicle Button
                                NavigationLink(destination: SettingsView()) {
                                    HStack {
                                        Spacer()
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .appFont(size: 32, weight: .semibold)
                                            .foregroundColor(.orange)
                                        
                                        Spacer()
                                    }
                                    .frame(height: 44)
                                    .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Estimate History Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("ESTIMATE HISTORY")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                NavigationLink(destination: NotificationsView()) {
                                    Text(syncService.isSyncing ? "SYNCING..." : "VIEW ALERTS")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(estimateHistory, id: \.number) { estimate in
                                    HStack(spacing: 12) {
                                        // Number Badge
                                        ZStack {
                                            Circle()
                                                .fill(Color(UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1)))
                                                .frame(width: 40, height: 40)
                                            
                                            Text(estimate.number)
                                                .appFont(size: 14, weight: .bold)
                                                .foregroundColor(.orange)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(estimate.name)
                                                .appFont(size: 13, weight: .semibold)
                                                .foregroundColor(.primary)
                                            
                                            Text(estimate.status)
                                                .appFont(size: 10, weight: .regular)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(estimate.price)
                                                .appFont(size: 13, weight: .bold)
                                                .foregroundColor(.primary)
                                            
                                            Text("Latest")
                                                .appFont(size: 9, weight: .regular)
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            
                            // View Full History Button
                            NavigationLink(destination: NotificationsView()) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .appFont(size: 14, weight: .semibold)
                                    
                                    Text("VIEW FULL HISTORY")
                                        .appFont(size: 14, weight: .semibold)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .foregroundColor(.white)
                                .background(Color(red: 1, green: 0.6, blue: 0.2))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
            }
        }
        .task {
            if authService.isAuthenticated {
                await repairRequestService.fetchMyRepairRequests()
            }
        }
        }
    }
}

#Preview {
    ProfileView(selectedTab: .constant("profile"))
}
