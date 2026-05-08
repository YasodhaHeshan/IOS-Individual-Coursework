import SwiftUI

struct WriteReviewView: View {
    @State private var isSubmitting = false
    @State private var selectedRating: Int = 0
    @State private var reviewTitle: String = ""
    @State private var reviewDescription: String = ""
    @State private var selectedGarage: String = "Select Garage"
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedGarage: String = "Select Garage") {
        _selectedGarage = State(initialValue: selectedGarage)
    }
    
    let garages = ["Colombo Auto Works", "Express Car Care", "Apex Premium Service"]
    
    var isFormValid: Bool {
        selectedGarage != "Select Garage" &&
        selectedRating > 0 && !reviewTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        !reviewDescription.trimmingCharacters(in: .whitespaces).isEmpty
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
                                Text("Write Review")
                                    .appFont(size: 14, weight: .semibold)
                            }
                            .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("SHARE YOUR EXPERIENCE")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                Text("Write Review")
                                    .appFont(size: 28, weight: .bold)
                                
                                Text("Tell other users about your experience with this garage.")
                                    .appFont(size: 14, weight: .regular)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            // Select Garage
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SELECT GARAGE")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(selectedGarage)
                                        .appFont(size: 16, weight: .regular)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                            
                            // Rating
                            VStack(alignment: .leading, spacing: 12) {
                                Text("RATE YOUR EXPERIENCE")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    ForEach(1...5, id: \.self) { star in
                                        Button(action: { selectedRating = star }) {
                                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                                .appFont(size: 28)
                                                .foregroundColor(star <= selectedRating ? .orange : .gray.opacity(0.3))
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(10)
                                
                                HStack(spacing: 8) {
                                    Text("You rated:")
                                        .appFont(size: 12, weight: .regular)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(selectedRating) stars")
                                        .appFont(size: 13, weight: .semibold)
                                        .foregroundColor(.orange)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Review Title
                            VStack(alignment: .leading, spacing: 12) {
                                Text("REVIEW TITLE")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                TextField("E.g. Great service and fair pricing", text: $reviewTitle)
                                    .appFont(size: 14, weight: .regular)
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Review Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DETAILED REVIEW")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                TextField("Share your detailed experience...", text: $reviewDescription, axis: .vertical)
                                    .lineLimit(4...6)
                                    .appFont(size: 14, weight: .regular)
                                    .padding(12)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Info Card
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .appFont(size: 16)
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Help others decide")
                                        .appFont(size: 12, weight: .semibold)
                                    
                                    Text("Your honest review helps other vehicle owners find the best service centers.")
                                        .appFont(size: 11, weight: .regular)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(red: 1.0, green: 0.95, blue: 0.9))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    
                    // Submit Button
                    VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                await submitReview()
                            }
                        }) {
                            ZStack {
                                HStack(spacing: 8) {
                                    Text("Submit Review")
                                    Image(systemName: "arrow.right")
                                }
                                .appFont(size: 16, weight: .semibold)
                                .foregroundColor(.white)

                                if isSubmitting {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isFormValid && !isSubmitting ? Color.orange : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid || isSubmitting)
                        
                        Text("Your review will be moderated before appearing")
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
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertTitle == "Review Submitted" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func submitReview() async {
        let trimmedTitle = reviewTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = reviewDescription.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isFormValid else { return }
        guard let userId = AuthService.shared.currentUser?.id else {
            await MainActor.run {
                alertTitle = "Sign In Required"
                alertMessage = "Please sign in before submitting a review."
                showAlert = true
            }
            return
        }

        await MainActor.run {
            isSubmitting = true
            showAlert = false
        }

        do {
            try await SupabaseService.shared.createGarageReview(
                userId: userId,
                garageName: selectedGarage,
                rating: selectedRating,
                reviewTitle: trimmedTitle,
                reviewDescription: trimmedDescription
            )

            await MainActor.run {
                isSubmitting = false
                alertTitle = "Review Submitted"
                alertMessage = "Thanks for sharing your experience."
                showAlert = true
            }
        } catch {
            await MainActor.run {
                isSubmitting = false
                alertTitle = "Couldn’t Save Review"
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

#Preview {
    WriteReviewView(selectedGarage: "Colombo Auto Works")
}
