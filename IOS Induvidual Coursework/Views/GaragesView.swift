import SwiftUI

struct GaragesView: View {
    @State private var selectedTab: String = "nearby"
    @State private var searchText: String = ""
    @StateObject private var garageService = GarageService.shared
    @StateObject private var locationService = LocationService.shared
    
    private var displayedGarages: [Garage] {
        let sourceGarages: [Garage]
        
        switch selectedTab {
        case "nearby":
            sourceGarages = garageService.nearbyGarages.isEmpty ? garageService.garages : garageService.nearbyGarages
        case "topRated":
            sourceGarages = garageService.garages.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }
        default:
            sourceGarages = garageService.garages
        }
        
        guard !searchText.isEmpty else { return sourceGarages }
        
        return sourceGarages.filter { garage in
            garage.name.localizedCaseInsensitiveContains(searchText) ||
            garage.location.localizedCaseInsensitiveContains(searchText) ||
            garage.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
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
                                .appFont(size: 18, weight: .semibold)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .appFont(size: 20)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .appFont(size: 14, weight: .semibold)
                                .foregroundColor(.gray)
                            
                            TextField("Search", text: $searchText)
                                .appFont(size: 14)
                                .tint(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(8)
                        
                        Image(systemName: "slider.horizontal.3")
                            .appFont(size: 16, weight: .semibold)
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
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.white)
                                Image(systemName: "line.3.horizontal.decrease")
                                    .appFont(size: 10, weight: .semibold)
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
                                .appFont(size: 11, weight: .semibold)
                                .foregroundColor(.gray)
                            
                            Text(selectedTab == "topRated" ? "Top Rated Experts" : "Nearby Experts")
                                .appFont(size: 16, weight: .semibold)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }

                        if garageService.isLoading {
                            ProgressView("Loading garages...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 24)
                        } else if let errorMessage = garageService.errorMessage {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Failed to load garages")
                                    .appFont(size: 14, weight: .semibold)
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .appFont(size: 12, weight: .regular)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                        } else if displayedGarages.isEmpty {
                            Text("No garages found")
                                .appFont(size: 13, weight: .regular)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 8)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(displayedGarages) { garage in
                                        GarageListItemView(garage: garage)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            await loadGarages()
        }
    }
    
    private func loadGarages() async {
        locationService.requestLocationPermission()
        locationService.startUpdatingLocation()
        await garageService.fetchAllGarages()
        await garageService.findNearbyGarages()
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
                    .appFont(size: 14, weight: .semibold)
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
            if let imageURLString = garage.imageURL,
               let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                                .tint(.orange)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo.fill")
                                .appFont(size: 40)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    @unknown default:
                        ZStack {
                            Color.gray.opacity(0.2)
                        }
                    }
                }
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "building.2.fill")
                        .appFont(size: 40)
                        .foregroundColor(.gray.opacity(0.5))
                }
                .frame(height: 180)
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Name
                Text(garage.name)
                    .appFont(size: 16, weight: .semibold)
                    .foregroundColor(.black)
                
                // Location
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .appFont(size: 12)
                        .foregroundColor(.gray)
                    
                    Text(garage.location)
                        .appFont(size: 12, weight: .regular)
                        .foregroundColor(.gray)
                }
                
                // Rating and Price
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .appFont(size: 12)
                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        
                        Text(String(format: "%.1f", garage.rating ?? 0.0))
                            .appFont(size: 12, weight: .semibold)
                            .foregroundColor(.black)
                        
                        Text("(\(garage.reviewCount ?? 0))")
                            .appFont(size: 11)
                            .foregroundColor(.gray)
                    }
                    
                    Text(garage.priceRange)
                        .appFont(size: 12, weight: .semibold)
                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                }
                
                // Buttons
                HStack(spacing: 8) {
                    NavigationLink(destination: GarageDetailView(garage: garage)) {
                        Text("View Details")
                            .appFont(size: 13, weight: .semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Text("Contact")
                            .appFont(size: 13, weight: .semibold)
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
