import SwiftUI
import PhotosUI
import UIKit

struct DescribeProblemView: View {
    let vehicleType: String
    let vehicleMake: String
    let vehicleModel: String
    let vehicleYear: Int

    @State private var issueSummary: String = ""
    @State private var detailedDescription: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var uploadedImageURLs: [String] = []
    @State private var generatedEstimate: RepairCostEstimate?
    @State private var predictedCategory: String = "General Damage"
    @State private var isSubmitting = false
    @State private var formError: String?
    @State private var shouldNavigateToReport = false

    @StateObject private var imageAnalysisService = ImageAnalysisService.shared
    @StateObject private var damagePredictionService = DamagePredictionService.shared
    @StateObject private var imageUploadService = ImageUploadService.shared

    @Environment(\.presentationMode) var presentationMode
    
    var isFormValid: Bool {
        !issueSummary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !detailedDescription.trimmingCharacters(in: .whitespaces).isEmpty
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
                                Text("Report Issue")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Describe the problem.")
                                    .font(.system(size: 28, weight: .bold))
                                
                                Text("Explain your vehicle problem in detail to get an accurate diagnostic result.")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            // Brief Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("BRIEF DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("Describe your issue...", text: $issueSummary, axis: .vertical)
                                    .lineLimit(3...5)
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Detailed Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DETAILED DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("E.g. Ping noises heard when accelerating or hear bumper sounds...", text: $detailedDescription, axis: .vertical)
                                    .lineLimit(3...5)
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Visual Evidence
                            VStack(alignment: .leading, spacing: 12) {
                                Text("VISUAL EVIDENCE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)

                                HStack(spacing: 12) {
                                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                        VStack(spacing: 8) {
                                            if selectedImage != nil {
                                                Image(systemName: "photo.fill")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.orange)
                                                Text("CHANGE")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.orange)
                                            } else {
                                                Image(systemName: "camera")
                                                    .font(.system(size: 22, weight: .semibold))
                                                    .foregroundColor(.gray)
                                                Text("UPLOAD")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 90)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                                .foregroundColor(Color.gray.opacity(0.4))
                                        )
                                    }

                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "info.circle.fill")
                                                .foregroundColor(.orange)
                                            Text("Clear photos help us provide 95% accurate estimates")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }

                                        if let selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 52)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .cornerRadius(8)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 90)
                                    .padding(.horizontal, 12)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }

                                if let formError {
                                    Text(formError)
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.red)
                                }

                                if isSubmitting || imageAnalysisService.isAnalyzing || damagePredictionService.isLoading || imageUploadService.isUploading {
                                    HStack(spacing: 8) {
                                        ProgressView()
                                        Text("Analyzing damage and preparing estimate...")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    
                    // Calculate Cost Button
                    VStack(spacing: 12) {
                        Button {
                            Task {
                                await calculateEstimate()
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Calculate Cost")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isFormValid && !isSubmitting ? Color.orange : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid || isSubmitting)
                        
                        Text("By continuing, you agree to our terms of service")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, TabBarLayout.bottomClearance)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $shouldNavigateToReport) {
                if let generatedEstimate {
                    ReportIssueView(
                        estimate: generatedEstimate,
                        vehicleMake: vehicleMake,
                        vehicleModel: vehicleModel,
                        vehicleYear: vehicleYear,
                        issueDescription: "\(issueSummary) \(detailedDescription)",
                        damageCategory: predictedCategory,
                        imageURLs: uploadedImageURLs
                    )
                }
            }
            .onChange(of: selectedPhotoItem) { newItem in
                guard let newItem else { return }
                Task {
                    await loadSelectedImage(from: newItem)
                }
            }
        }
    }

    private func loadSelectedImage(from item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                formError = "Unable to load selected image"
                return
            }

            selectedImage = image
            formError = nil
        } catch {
            formError = error.localizedDescription
        }
    }

    private func calculateEstimate() async {
        guard isFormValid else { return }

        isSubmitting = true
        formError = nil
        uploadedImageURLs.removeAll()

        var severity: DamageSeverity = .medium
        var predicted = "General Damage"

        if let selectedImage {
            let quality = imageAnalysisService.checkImageQuality(selectedImage)
            if case .poor(let reason) = quality {
                formError = reason
                isSubmitting = false
                return
            }

            if let analysis = await imageAnalysisService.analyzeDamageImage(selectedImage) {
                severity = analysis.severity
            }

            if let prediction = await damagePredictionService.predictDamageCategory(image: selectedImage) {
                predicted = prediction.category
            }

            do {
                let path = try await imageUploadService.uploadImage(
                    selectedImage,
                    to: "repair-uploads",
                    filename: "repair_\(UUID().uuidString).jpg"
                )
                uploadedImageURLs = [path]
            } catch {
                formError = "Image upload skipped: \(error.localizedDescription)"
            }
        }

        predictedCategory = predicted
        let costEstimate = damagePredictionService.estimateRepairCost(
            damageCategory: predicted,
            severity: severity,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel
        )
        let suggestedParts = damagePredictionService.suggestSpareParts(
            damageCategory: predicted,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel
        )

        generatedEstimate = RepairCostEstimate(
            totalCost: String(format: "%.1fK", costEstimate.midEstimate / 1000),
            currency: "LKR",
            priceLabel: "Repair • LKR • \(vehicleMake)",
            partsName: suggestedParts.first?.name ?? "General Parts",
            partsCost: "LKR \(Int(costEstimate.lowEstimate))",
            laborName: "Labor",
            laborCost: "LKR \(Int(max(1000, costEstimate.midEstimate - costEstimate.lowEstimate)))",
            laborHours: "Estimated 2-4 hours",
            analysisSummary: [
                RepairCostEstimate.AnalysisPoint(
                    title: "AI Damage Prediction",
                    description: "Category: \(predicted), severity: \(severity.rawValue), confidence: \(Int(costEstimate.confidence * 100))%."
                ),
                RepairCostEstimate.AnalysisPoint(
                    title: "Vehicle Context",
                    description: "Estimate tuned for \(vehicleYear) \(vehicleMake) \(vehicleModel) based on current service patterns."
                )
            ],
            garageComparison: [
                RepairCostEstimate.GarageInfo(name: "Nearby Verified Garages", icon: "building.2.fill"),
                RepairCostEstimate.GarageInfo(name: "Top Rated Specialists", icon: "wrench.and.screwdriver.fill")
            ]
        )

        isSubmitting = false
        shouldNavigateToReport = true
    }
}

#Preview {
    DescribeProblemView(vehicleType: "Car", vehicleMake: "Toyota", vehicleModel: "Prius", vehicleYear: 2022)
}
