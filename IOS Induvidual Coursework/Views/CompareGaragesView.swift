import SwiftUI

struct CompareGaragesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var garageService = GarageService.shared
    @StateObject private var locationService = LocationService.shared
    @State private var searchText: String = ""
    @State private var showMapView: Bool = false
    @State private var selectedGarageForMap: Garage?

    private var topGarages: [Garage] {
        let source = garageService.nearbyGarages.isEmpty ? garageService.garages : garageService.nearbyGarages
        let list = Array(source.prefix(3))
        if !list.isEmpty { return list }

        return Array(sampleGarages.prefix(3))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Compare Garages")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await loadGaragesIfNeeded()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(topGarages) { garage in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Top Row: Name and Rating
                                    HStack(alignment: .top, spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(garage.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            HStack(spacing: 2) {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.orange)

                                                if let rating = garage.rating {
                                                    Text(String(format: "%.1f", rating))
                                                        .font(.system(size: 12, weight: .semibold))
                                                        .foregroundColor(.black)
                                                } else {
                                                    Text("–")
                                                        .font(.system(size: 12, weight: .semibold))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    
                                    // Distance
                                    HStack(spacing: 6) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(.gray)
                                        
                                        Text(distanceText(for: garage))
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    // Price
                                    Text(garage.priceRange)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    // Hours and Category
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .font(.system(size: 10))
                                                .foregroundColor(.orange)

                                            Text(garage.openHours ?? "Hours unavailable")
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        HStack(spacing: 4) {
                                            Image(systemName: "wrench.and.screwdriver")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)

                                            Text(garage.category)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()
                                    }
                                    
                                    // Action Buttons
                                    HStack(spacing: 12) {
                                        Button(action: {
                                            selectedGarageForMap = garage
                                        }) {
                                            Text("VIEW MAP")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.orange)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 40)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.orange, lineWidth: 1)
                                                )
                                        }
                                        
                                        Button(action: {
                                            if let phone = garage.phone, let url = URL(string: "tel://\(phone.filter { $0.isNumber })") {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text("CONTACT")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 40)
                                                .background(Color.orange)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            
                            Spacer()
                                .frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    // Bottom Button
                    VStack(spacing: 12) {
                        Button(action: { showMapView.toggle() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("SHOW MAP VIEW")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, TabBarLayout.bottomClearance)
                }
            }
            .navigationBarBackButtonHidden(true)
            .task {
                await loadGaragesIfNeeded()
            }
                    .sheet(item: $selectedGarageForMap) { garage in
                        GarageMapView(garage: garage)
                    }
                    .sheet(isPresented: $showMapView) {
                        CompareMapView(garages: topGarages)
                    }
        }
    }

    private func loadGaragesIfNeeded() async {
        locationService.requestLocationPermission()
        locationService.startUpdatingLocation()

        if garageService.garages.isEmpty {
            await garageService.fetchAllGarages()
        }
        if garageService.nearbyGarages.isEmpty {
            await garageService.findNearbyGarages()
        }
    }

    private func distanceText(for garage: Garage) -> String {
        if let d = garage.distance {
            return d
        }
        if let meters = garageService.getDistance(to: garage) {
            return String(format: "%.1f km away", meters / 1000)
        }
        return "Distance unavailable"
    }
}

struct GarageResult {
    let name: String
    let rating: Double
    let distance: String
    let price: String
    let availability: String
    let warranty: String
}

#Preview {
    CompareGaragesView()
}
