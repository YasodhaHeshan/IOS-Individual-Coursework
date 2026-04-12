import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: String = "home"
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case "profile":
                ProfileView(selectedTab: $selectedTab)
                    .transition(.opacity)
            default:
                HomeView(selectedTab: $selectedTab)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    MainTabView()
}
