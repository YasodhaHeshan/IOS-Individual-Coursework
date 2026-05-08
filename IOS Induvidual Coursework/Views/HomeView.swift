import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String
    @State private var searchTab: SearchTab = .typeIssue
    @State private var issueInput: String = ""
    @State private var selectedIssue: String = ""
    @State private var showRecentSearches = true
    @StateObject private var garageService = GarageService.shared
    @StateObject private var repairRequestService = RepairRequestService.shared
    @StateObject private var locationService = LocationService.shared
    @StateObject private var authService = AuthService.shared
    @StateObject private var notificationService = NotificationService.shared
    
    enum SearchTab {
        case typeIssue
        case selectIssue
    }
    
    private var recentSearches: [(String, String)] {
        let mappedRequests = repairRequestService.repairRequests.prefix(3).map { request in
            let title = request.damageCategory.isEmpty ? request.description : request.damageCategory
            let details = "\(request.vehicleMake) \(request.vehicleModel) • \(relativeDateString(from: request.createdAt))"
            return (title, details)
        }
        
        if !mappedRequests.isEmpty {
            return Array(mappedRequests)
        }
        
        return [
            ("Brake Pad Replacement", "Honda Civic • 5 days ago"),
            ("Engine Oil Leak", "Honda Civic • 5 days ago"),
            ("Alternator Repair", "BMW 320i • 3 days ago")
        ]
    }
    
    let categories = ["Engine", "Brakes", "Transmission", "Electrical", "Suspension"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("RepairCost LK")
                                .appFont(size: 14, weight: .semibold)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        NavigationLink(destination: NotificationsView()) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell")
                                    .appFont(size: 16, weight: .semibold)
                                    .foregroundColor(.black)

                                if notificationService.unreadCount > 0 {
                                    Text("\(min(notificationService.unreadCount, 9))")
                                        .appFont(size: 10, weight: .bold)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.orange)
                                        .clipShape(Circle())
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Hero Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("FIX IT.")
                                    .appFont(size: 40, weight: .bold)
                                    .foregroundColor(.black)
                            
                            Text("ESTIMATE REPAIR COSTS IN SECONDS.")
                                .appFont(size: 13, weight: .regular)
                                .foregroundColor(.gray)
                                .lineLimit(3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Search Section
                        VStack(spacing: 12) {
                            // Tab Selection
                            HStack(spacing: 0) {
                                Button(action: {
                                    searchTab = .typeIssue
                                    selectedIssue = ""
                                }) {
                                    Text("Type issue")
                                        .appFont(size: 15, weight: .semibold)
                                        .foregroundColor(searchTab == .typeIssue ? .init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)) : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                    
                                    if searchTab == .typeIssue {
                                        VStack {
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                                .frame(height: 2)
                                        }
                                    }
                                }
                                
                                Button(action: {
                                    searchTab = .selectIssue
                                    issueInput = ""
                                }) {
                                    Text("Select issue")
                                        .appFont(size: 15, weight: .semibold)
                                        .foregroundColor(searchTab == .selectIssue ? .init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)) : .gray)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                    
                                    if searchTab == .selectIssue {
                                        VStack {
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                                .frame(height: 2)
                                        }
                                    }
                                }
                            }
                            .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                            .cornerRadius(12)
                            
                            // Content based on selected tab
                            if searchTab == .typeIssue {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Type Issue")
                                            .appFont(size: 11, weight: .semibold)
                                            .foregroundColor(.gray)
                                        TextField("Enter issue", text: $issueInput)
                                            .appFont(size: 14, weight: .regular)
                                    }
                                    Spacer()
                                }
                                .padding(16)
                                .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                .cornerRadius(12)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(categories, id: \.self) { category in
                                        Button(action: {
                                            selectedIssue = category
                                        }) {
                                            HStack {
                                                Image(systemName: getCategoryIcon(category))
                                                    .appFont(size: 16, weight: .semibold)
                                                    .foregroundColor(.orange)
                                                
                                                Text(category)
                                                    .appFont(size: 14, weight: .semibold)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if selectedIssue == category {
                                                    Image(systemName: "checkmark")
                                                        .appFont(size: 14, weight: .semibold)
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            .padding(12)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Quick Actions
                        VStack(alignment: .leading, spacing: 12) {
                            // Estimate Cost Button
                            NavigationLink(destination: SelectVehicleView()) {
                                HStack(spacing: 12) {
                                    Image(systemName: "doc.richtext")
                                        .appFont(size: 18, weight: .semibold)
                                        .foregroundColor(.white)
                                    
                                    Text("Estimate Cost")
                                        .appFont(size: 16, weight: .semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color(red: 1, green: 0.6, blue: 0.2))
                                .cornerRadius(12)
                            }
                            
                            // Secondary Actions
                            HStack(spacing: 12) {
                                Button(action: {
                                    selectedTab = "garages"
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "building.2")
                                            .appFont(size: 20, weight: .semibold)
                                            .foregroundColor(.orange)
                                        Text("Find Garage")
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    selectedTab = "spareParts"
                                }) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "gearshape")
                                            .appFont(size: 20, weight: .semibold)
                                            .foregroundColor(.orange)
                                        Text("Spare Parts")
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Recent Searches
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("RECENT SEARCHES")
                                    .appFont(size: 12, weight: .bold)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {
                                    showRecentSearches = false
                                }) {
                                    Text("CLEAR ALL")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            if showRecentSearches {
                                VStack(spacing: 10) {
                                    ForEach(recentSearches, id: \.0) { search, details in
                                        HStack(spacing: 12) {
                                            Image(systemName: "clock")
                                                .appFont(size: 14, weight: .semibold)
                                                .foregroundColor(.gray)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(search)
                                                    .appFont(size: 14, weight: .semibold)
                                                    .foregroundColor(.black)
                                                Text(details)
                                                    .appFont(size: 11, weight: .regular)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .appFont(size: 12, weight: .semibold)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                    }
                                }
                            } else {
                                Text("Recent searches cleared")
                                    .appFont(size: 12, weight: .regular)
                                    .foregroundColor(.gray)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        showRecentSearches = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Certified Garage Program
                        VStack(spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CERTIFIED GARAGE PROGRAM")
                                        .appFont(size: 12, weight: .bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Verified Expert Mechanical Services for reliable and durable repairs!")
                                        .appFont(size: 12, weight: .regular)
                                        .foregroundColor(.white)
                                        .lineLimit(3)
                                }
                                
                                Spacer()
                            }
                            
                            Button(action: {
                                selectedTab = "garages"
                            }) {
                                HStack(spacing: 4) {
                                    Text("LEARN MORE")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.right")
                                        .appFont(size: 10, weight: .semibold)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 8)
                            }
                        }
                        .padding(16)
                        .background(Color(red: 1, green: 0.6, blue: 0.2))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
                }
            }
        }
        .task {
            await loadDashboardData()
        }
    }
    
    private func getCategoryIcon(_ category: String) -> String {
        switch category {
        case "Engine":
            return "engine"
        case "Brakes":
            return "brake.radiator.fill"
        case "Transmission":
            return "gearshape"
        case "Electrical":
            return "bolt"
        case "Suspension":
            return "shippingbox"
        default:
            return "questionmark.circle"
        }
    }
    
    private func relativeDateString(from date: Date?) -> String {
        guard let date else { return "Recently" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func loadDashboardData() async {
        locationService.requestLocationPermission()
        locationService.startUpdatingLocation()
        await garageService.fetchAllGarages()
        if authService.isAuthenticated {
            await repairRequestService.fetchMyRepairRequests()
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant("home"))
}
