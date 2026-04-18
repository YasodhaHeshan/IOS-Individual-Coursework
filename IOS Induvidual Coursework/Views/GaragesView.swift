import SwiftUI

struct GaragesView: View {
    @State private var selectedTab: String = "nearby"
    @State private var searchText: String = ""
    @State private var selectedGarage: Garage?
    @State private var showDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Garages")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            TextField("Search", text: $searchText)
                                .font(.system(size: 14))
                                .tint(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // MARK: - Tabs
                    HStack(spacing: 16) {
                        TabButton(
                            title: "Nearby",
                            isSelected: selectedTab == "nearby",
                            action: { selectedTab = "nearby" }
                        )
                        
                        TabButton(
                            title: "Top Rated",
                            isSelected: selectedTab == "topRated",
                            action: { selectedTab = "topRated" }
                        )
                        
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Text("FILTER")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            .cornerRadius(6)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // MARK: - Results Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("RESULTS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Text("Nearby Experts")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(sampleGarages) { garage in
                                    GarageListItemView(garage: garage)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)) : .gray)
                
                if isSelected {
                    Rectangle()
                        .fill(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        .frame(height: 2)
                }
            }
        }
    }
}

// MARK: - Garage List Item View
struct GarageListItemView: View {
    let garage: Garage
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 12) {
            // Image
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 180)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Name
                Text(garage.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text(garage.location)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                // Rating and Price
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        
                        Text(String(format: "%.1f", garage.rating))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Text("(\(garage.reviewCount))")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    
                    Text(garage.priceRange)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                }
                
                // Buttons
                HStack(spacing: 8) {
                    NavigationLink(destination: GarageDetailView(garage: garage)) {
                        Text("View Details")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Text("Contact")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    GaragesView()
}
