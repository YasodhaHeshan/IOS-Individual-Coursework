import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: String
    @State private var searchTab: SearchTab = .typeIssue
    @State private var issueInput: String = ""
    @State private var selectedIssue: String = ""
    
    enum SearchTab {
        case typeIssue
        case selectIssue
    }
    
    let recentSearches = [
        ("Brake Pad Replacement", "Honda Civic • 5 days ago"),
        ("Engine Oil Leak", "Honda Civic • 5 days ago"),
        ("Alternator Repair", "BMW 320i • 3 days ago")
    ]
    
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
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        NavigationLink(destination: NotificationsView()) {
                            Image(systemName: "bell")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // MARK: - Hero Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("FIX IT.")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.black)
                            
                            Text("ESTIMATE REPAIR COSTS IN SECONDS.")
                                .font(.system(size: 13, weight: .regular))
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
                                        .font(.system(size: 15, weight: .semibold))
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
                                        .font(.system(size: 15, weight: .semibold))
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
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(.gray)
                                        TextField("Enter issue", text: $issueInput)
                                            .font(.system(size: 14, weight: .regular))
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
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.orange)
                                                
                                                Text(category)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if selectedIssue == category {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 14, weight: .semibold))
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
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("Estimate Cost")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color(red: 1, green: 0.6, blue: 0.2))
                                .cornerRadius(12)
                            }
                            
                            // Secondary Actions
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "building.2")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.orange)
                                        Text("Find Garage")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {}) {
                                    VStack(spacing: 8) {
                                        Image(systemName: "gearshape")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.orange)
                                        Text("Spare Parts")
                                            .font(.system(size: 12, weight: .semibold))
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
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("CLEAR ALL")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(recentSearches, id: \.0) { search, details in
                                    HStack(spacing: 12) {
                                        Image(systemName: "clock")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.gray)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(search)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text(details)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Certified Garage Program
                        VStack(spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CERTIFIED GARAGE PROGRAM")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Verified Expert Mechanical Services for reliable and durable repairs!")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.white)
                                        .lineLimit(3)
                                }
                                
                                Spacer()
                            }
                            
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Text("LEARN MORE")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10, weight: .semibold))
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
                    .safeAreaPadding(.bottom, 96)
                }
            }
        }
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
}

#Preview {
    HomeView(selectedTab: .constant("home"))
}
