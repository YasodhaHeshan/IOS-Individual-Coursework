import SwiftUI

struct ProfileView: View {
    @Binding var selectedTab: String
    
    let userData = (
        name: "Kasun Perera",
        subtitle: "service centers since 2021",
        garages: "6",
        ratings: "5"
    )
    
    let savedVehicles = [
        (name: "Toyota Prius", services: "3 car services"),
        (name: "Honda Hornet", services: "2 car services")
    ]
    
    let estimateHistory = [
        (number: "01", name: "Bumper Repair", price: "LKR 45,000", status: "Urgent Fix"),
        (number: "05", name: "Engine Tune-up", price: "LKR 12,000", status: "Urgent"),
        (number: "28", name: "Brake Pad Change", price: "LKR 8,500", status: "Completed")
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Text("Profile")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - Profile Section
                        VStack(spacing: 12) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color(UIColor(red: 0.95, green: 0.85, blue: 0.75, alpha: 1)))
                                    .frame(width: 80, height: 80)
                                
                                Text("KP")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.orange)
                            }
                            
                            Text(userData.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(userData.subtitle)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                            
                            // Stats
                            HStack(spacing: 24) {
                                VStack(spacing: 4) {
                                    Text(userData.garages)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                    
                                    Text("GARAGES")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                                
                                Divider()
                                    .frame(height: 30)
                                
                                VStack(spacing: 4) {
                                    Text(userData.ratings)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.orange)
                                    
                                    Text("RATINGS")
                                        .font(.system(size: 10, weight: .semibold))
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
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("VIEW ALL")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(savedVehicles, id: \.name) { vehicle in
                                    HStack(spacing: 12) {
                                        Image(systemName: "car.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.orange)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(vehicle.name)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Text(vehicle.services)
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
                                
                                // Add Vehicle Button
                                Button(action: {}) {
                                    HStack {
                                        Spacer()
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 32, weight: .semibold))
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
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("LAST HISTORY")
                                        .font(.system(size: 12, weight: .semibold))
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
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(estimate.name)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.black)
                                            
                                            Text(estimate.status)
                                                .font(.system(size: 10, weight: .regular))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(estimate.price)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(.black)
                                            
                                            Text("Latest")
                                                .font(.system(size: 9, weight: .regular))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                            
                            // View Full History Button
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("VIEW FULL HISTORY")
                                        .font(.system(size: 14, weight: .semibold))
                                    
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
                .safeAreaPadding(.bottom, 96)
            }
        }
    }
}

#Preview {
    ProfileView(selectedTab: .constant("profile"))
}
