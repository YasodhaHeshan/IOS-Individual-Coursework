import SwiftUI

struct CompareGaragesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var showMapView: Bool = false
    
    let garages = [
        GarageResult(
            name: "Colombo Auto Works",
            rating: 4.6,
            distance: "0.5 km away (Wellawatta)",
            price: "LKR 41,800",
            availability: "AVAILABLE • TOMORROW",
            warranty: "NO WARRANTY"
        ),
        GarageResult(
            name: "Express Car Care",
            rating: 4.3,
            distance: "1.3 km away (Bambalapitiya)",
            price: "LKR 38,500",
            availability: "AVAILABLE • 2 DAYS",
            warranty: "2 MO WARRANTY"
        ),
        GarageResult(
            name: "Apex Premium Service",
            rating: 4.9,
            distance: "0.8 km away (Close By)",
            price: "LKR 46,000",
            availability: "AVAILABLE • SAME DAY",
            warranty: "6 MO WARRANTY"
        )
    ]
    
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
                        
                        Button(action: {}) {
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
                            ForEach(garages, id: \.name) { garage in
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
                                                
                                                Text("\(String(format: "%.1f", garage.rating))")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    
                                    // Distance
                                    HStack(spacing: 6) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(.gray)
                                        
                                        Text(garage.distance)
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    // Price
                                    Text(garage.price)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    // Availability and Warranty
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.orange)
                                            
                                            Text(garage.availability)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "clock")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                            
                                            Text(garage.warranty)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    // Action Buttons
                                    HStack(spacing: 12) {
                                        Button(action: {}) {
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
                                        
                                        Button(action: {}) {
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
                    .padding(.bottom, 96)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
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
