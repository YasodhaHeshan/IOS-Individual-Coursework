import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: String = "home"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Content View
                switch selectedTab {
                case "garages":
                    GaragesView()
                        .transition(.opacity)
                case "spareParts":
                    SparePartsView()
                        .transition(.opacity)
                case "profile":
                    ProfileView(selectedTab: $selectedTab)
                        .transition(.opacity)
                default:
                    HomeView(selectedTab: $selectedTab)
                        .transition(.opacity)
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack(spacing: 0) {
                    TabBarItem(
                        icon: "house.fill",
                        label: "Home",
                        isSelected: selectedTab == "home",
                        action: { selectedTab = "home" }
                    )
                    
                    TabBarItem(
                        icon: "building.2.fill",
                        label: "Garages",
                        isSelected: selectedTab == "garages",
                        action: { selectedTab = "garages" }
                    )
                    
                    TabBarItem(
                        icon: "wrench.and.screwdriver.fill",
                        label: "Spare Parts",
                        isSelected: selectedTab == "spareParts",
                        action: { selectedTab = "spareParts" }
                    )
                    
                    TabBarItem(
                        icon: "person.fill",
                        label: "Profile",
                        isSelected: selectedTab == "profile",
                        action: { selectedTab = "profile" }
                    )
                }
                .frame(height: 70)
                .background(Color.white)
                .border(Color.gray.opacity(0.2), width: 1)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

// MARK: - Tab Bar Item Component
struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)) : .gray)
                
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isSelected ? .init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)) : .gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
