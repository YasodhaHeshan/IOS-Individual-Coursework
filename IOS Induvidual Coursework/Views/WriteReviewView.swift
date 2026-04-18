import SwiftUI

struct WriteReviewView: View {
    @State private var selectedRating: Int = 0
    @State private var reviewTitle: String = ""
    @State private var reviewDescription: String = ""
    @State private var selectedGarage: String = "Select Garage"
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedGarage: String = "Select Garage") {
        _selectedGarage = State(initialValue: selectedGarage)
    }
    
    let garages = ["Colombo Auto Works", "Express Car Care", "Apex Premium Service"]
    
    var isFormValid: Bool {
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
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Write Review")
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
                                Text("SHARE YOUR EXPERIENCE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Write Review")
                                    .font(.system(size: 28, weight: .bold))
                                
                                Text("Tell other users about your experience with this garage.")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            // Select Garage
                            VStack(alignment: .leading, spacing: 12) {
                                Text("SELECT GARAGE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(selectedGarage)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                            
                            // Rating
                            VStack(alignment: .leading, spacing: 12) {
                                Text("RATE YOUR EXPERIENCE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    ForEach(1...5, id: \.self) { star in
                                        Button(action: { selectedRating = star }) {
                                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                                .font(.system(size: 28))
                                                .foregroundColor(star <= selectedRating ? .orange : .gray.opacity(0.3))
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                HStack(spacing: 8) {
                                    Text("You rated:")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.gray)
                                    
                                    Text("\(selectedRating) stars")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.orange)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Review Title
                            VStack(alignment: .leading, spacing: 12) {
                                Text("REVIEW TITLE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("E.g. Great service and fair pricing", text: $reviewTitle)
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
                            
                            // Review Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DETAILED REVIEW")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("Share your detailed experience...", text: $reviewDescription, axis: .vertical)
                                    .lineLimit(4...6)
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
                            
                            // Info Card
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Help others decide")
                                        .font(.system(size: 12, weight: .semibold))
                                    
                                    Text("Your honest review helps other vehicle owners find the best service centers.")
                                        .font(.system(size: 11, weight: .regular))
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
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Text("Submit Review")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isFormValid ? Color.orange : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid)
                        
                        Text("Your review will be moderated before appearing")
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
    WriteReviewView(selectedGarage: "Colombo Auto Works")
}
