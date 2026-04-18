import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: String = "home"
    
    var body: some View {
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
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 8) {
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
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.10), radius: 18, x: 0, y: 6)
            .padding(.horizontal, 16)
            .padding(.top, 8)
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
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                isSelected ?
                    AnyView(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.orange.opacity(0.8),
                                        Color.orange.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.orange.opacity(0.4), radius: 8, x: 0, y: 4)
                    ) :
                    AnyView(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.05))
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }
}

#Preview {
    MainTabView()
}
