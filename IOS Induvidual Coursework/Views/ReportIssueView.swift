import SwiftUI

struct ReportIssueView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var repairRequestService = RepairRequestService.shared
    @StateObject private var notificationService = NotificationService.shared

    let estimate: RepairCostEstimate
    let vehicleMake: String
    let vehicleModel: String
    let vehicleYear: Int
    let issueDescription: String
    let damageCategory: String
    let imageURLs: [String]

    @State private var isSubmittingRequest = false
    @State private var requestError: String?
    @State private var navigateToComparison = false

    init(
        estimate: RepairCostEstimate = RepairCostEstimate(
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
        ),
        vehicleMake: String = "Toyota",
        vehicleModel: String = "Prius",
        vehicleYear: Int = 2022,
        issueDescription: String = "General issue reported",
        damageCategory: String = "General Damage",
        imageURLs: [String] = []
    ) {
        self.estimate = estimate
        self.vehicleMake = vehicleMake
        self.vehicleModel = vehicleModel
        self.vehicleYear = vehicleYear
        self.issueDescription = issueDescription
        self.damageCategory = damageCategory
        self.imageURLs = imageURLs
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
                                    .appFont(size: 16, weight: .semibold)
                                Text("RepairCost LK")
                                    .appFont(size: 14, weight: .semibold)
                            }
                            .foregroundColor(.primary)
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
                                        .appFont(size: 16)
                                        .foregroundColor(.orange)
                                    
                                    Text("Report Issue")
                                        .appFont(size: 12, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack(alignment: .bottom, spacing: 8) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("LKR \(estimate.totalCost)")
                                            .appFont(size: 36, weight: .bold)
                                        
                                        Text(estimate.priceLabel)
                                            .appFont(size: 12, weight: .regular)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            
                            // Cost Breakdown
                            VStack(spacing: 0) {
                                // Parts
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Parts")
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.gray)
                                        
                                        Text(estimate.partsName)
                                            .appFont(size: 14, weight: .regular)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(estimate.partsCost)
                                            .appFont(size: 12, weight: .semibold)
                                        
                                        Text("Per Unit")
                                            .appFont(size: 11, weight: .regular)
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
                                            .appFont(size: 12, weight: .semibold)
                                            .foregroundColor(.gray)
                                        
                                        Text(estimate.laborHours)
                                            .appFont(size: 14, weight: .regular)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(estimate.laborCost)
                                            .appFont(size: 12, weight: .semibold)
                                        
                                        Text("Hourly")
                                            .appFont(size: 11, weight: .regular)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(16)
                            }
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            
                            // Analysis Summary
                            VStack(alignment: .leading, spacing: 12) {
                                Text("ANALYSIS SUMMARY")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                VStack(spacing: 12) {
                                    ForEach(estimate.analysisSummary, id: \.title) { point in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: "info.circle.fill")
                                                .appFont(size: 16)
                                                .foregroundColor(.orange)
                                                .padding(.top, 2)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(point.title)
                                                    .appFont(size: 13, weight: .semibold)
                                                
                                                Text(point.description)
                                                    .appFont(size: 12, weight: .regular)
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
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 10) {
                                    ForEach(estimate.garageComparison, id: \.name) { garage in
                                        VStack(spacing: 8) {
                                            Image(systemName: garage.icon)
                                                .appFont(size: 24)
                                                .foregroundColor(.orange)
                                            
                                            Text(garage.name)
                                                .appFont(size: 10, weight: .semibold)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
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
                        Button {
                            Task {
                                await submitRepairRequestAndContinue()
                            }
                        } label: {
                            HStack(spacing: 8) {
                                if isSubmittingRequest {
                                    ProgressView()
                                        .tint(.white)
                                }

                                Text("Compare Garages")
                                Image(systemName: "arrow.right")
                            }
                            .appFont(size: 16, weight: .semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isSubmittingRequest ? Color.gray.opacity(0.5) : Color.orange)
                            .cornerRadius(10)
                        }
                        .disabled(isSubmittingRequest)

                        if let requestError {
                            Text(requestError)
                                .appFont(size: 12, weight: .regular)
                                .foregroundColor(.red)
                        }
                        
                        Text("By continuing, you agree to our terms of service")
                            .appFont(size: 11, weight: .regular)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, TabBarLayout.bottomClearance)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToComparison) {
                CompareGaragesView()
            }
        }
    }

    private func submitRepairRequestAndContinue() async {
        isSubmittingRequest = true
        requestError = nil

        await repairRequestService.createRepairRequest(
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            vehicleYear: vehicleYear,
            description: issueDescription,
            damageCategory: damageCategory,
            imageURLs: imageURLs
        )

        if let serviceError = repairRequestService.errorMessage {
            requestError = serviceError
            isSubmittingRequest = false
            return
        }

        notificationService.addNotification(
            AppNotification(
                id: UUID().uuidString,
                title: "Repair Request Submitted",
                body: "Your \(vehicleMake) \(vehicleModel) request is now in review.",
                type: .requestCreated,
                read: false,
                createdAt: Date(),
                associatedRequestId: repairRequestService.currentRequest?.id
            )
        )
        notificationService.sendLocalNotification(
            title: "Request submitted",
            body: "We are matching you with nearby garages.",
            delay: 1
        )

        isSubmittingRequest = false
        navigateToComparison = true
    }
}

#Preview {
    ReportIssueView()
}
