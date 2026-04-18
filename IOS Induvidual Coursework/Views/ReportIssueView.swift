import SwiftUI

struct ReportIssueView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let estimate = RepairCostEstimate(
        totalCost: "42.5K",
        currency: "LKR",
        priceLabel: "Repair • LKR • Tata",
        partsName: "Brake Pads & Rotor",
        partsCost: "LKR 28,000",
        laborName: "Labor",
        laborCost: "LKR 14,500",
        laborHours: "Estimated 2-3 hours",
        analysisSummary: [
            RepairCostEstimate.AnalysisPoint(
                title: "Data-Driven Analysis",
                description: "Based on 2022 Toyota Camry regional data in Colombo. Actual prices may vary based on specific garage overhead."
            ),
            RepairCostEstimate.AnalysisPoint(
                title: "Warranty Coverage",
                description: "Includes standard 6-month warranty on parts and manufacturer warranty on parts."
            )
        ],
        garageComparison: [
            RepairCostEstimate.GarageInfo(name: "Pujith VR's Ideal Parts Outlet", icon: "building.2.fill"),
            RepairCostEstimate.GarageInfo(name: "Specialized Autoworks Colombo", icon: "wrench.and.screwdriver.fill")
        ]
    )
    
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
                                Text("RepairCost LK")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Estimated Total
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.orange)
                                    
                                    Text("Report Issue")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                                
                                HStack(alignment: .bottom, spacing: 8) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("LKR \(estimate.totalCost)")
                                            .font(.system(size: 36, weight: .bold))
                                        
                                        Text(estimate.priceLabel)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            
                            // Cost Breakdown
                            VStack(spacing: 0) {
                                // Parts
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Parts")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.gray)
                                        
                                        Text(estimate.partsName)
                                            .font(.system(size: 14, weight: .regular))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(estimate.partsCost)
                                            .font(.system(size: 12, weight: .semibold))
                                        
                                        Text("Per Unit")
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(16)
                                
                                Divider()
                                    .padding(.horizontal, 16)
                                
                                // Labor
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(estimate.laborName)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.gray)
                                        
                                        Text(estimate.laborHours)
                                            .font(.system(size: 14, weight: .regular))
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(estimate.laborCost)
                                            .font(.system(size: 12, weight: .semibold))
                                        
                                        Text("Hourly")
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(16)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            
                            // Analysis Summary
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ANALYSIS SUMMARY")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                VStack(spacing: 12) {
                                    ForEach(estimate.analysisSummary, id: \.title) { point in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "info.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.orange)
                                                .padding(.top, 2)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(point.title)
                                                    .font(.system(size: 13, weight: .semibold))
                                                
                                                Text(point.description)
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundColor(.gray)
                                                    .lineLimit(3)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color(red: 1.0, green: 0.95, blue: 0.9))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Garage Comparison
                            VStack(alignment: .leading, spacing: 12) {
                                Text("FOR NEAREST WORK AREA SHOP LOCATION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 10) {
                                    ForEach(estimate.garageComparison, id: \.name) { garage in
                                        VStack(spacing: 8) {
                                            Image(systemName: garage.icon)
                                                .font(.system(size: 24))
                                                .foregroundColor(.orange)
                                            
                                            Text(garage.name)
                                                .font(.system(size: 10, weight: .semibold))
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    
                    // Compare Garages Button
                    VStack(spacing: 12) {
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Text("Compare Garages")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.orange)
                            .cornerRadius(10)
                        }
                        
                        Text("By continuing, you agree to our terms of service")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ReportIssueView()
}
