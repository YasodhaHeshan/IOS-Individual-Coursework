import SwiftUI

struct GarageDetailView: View {
    @Environment(\.dismiss) var dismiss
    let garage: Garage
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header Image
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 240)
                            .overlay(
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(16)
                    }
                    
                    VStack(spacing: 20) {
                        // MARK: - Garage Info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Text(garage.name)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                
                                if garage.isVerified {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 14))
                                        Text("VERIFIED")
                                            .font(.system(size: 11, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                    .cornerRadius(4)
                                }
                            }
                            
                            // Rating
                            HStack(spacing: 12) {
                                HStack(spacing: 4) {
                                    ForEach(0..<5, id: \.self) { index in
                                        Image(systemName: index < Int(garage.rating) ? "star.fill" : "star")
                                            .font(.system(size: 14))
                                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String(format: "%.1f", garage.rating))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black)
                                    
                                    Text("(\(garage.reviewCount) Reviews)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Description
                            if let description = garage.description {
                                Text(description)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.gray)
                                    .lineSpacing(1.5)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK: - Address Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Address & Hours")
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                    
                                    if let address = garage.address {
                                        Text(address)
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "clock.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                    
                                    if let hours = garage.openHours {
                                        Text(hours)
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "phone.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                    
                                    if let phone = garage.phone {
                                        Text(phone)
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Action Buttons
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("GET DIRECTIONS")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                .cornerRadius(8)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: {}) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 14, weight: .semibold))
                                        
                                        Text("CONTACT")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.black)
                                    .cornerRadius(8)
                                }
                                
                                NavigationLink(destination: WriteReviewView(selectedGarage: garage.name)) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14, weight: .semibold))
                                        
                                        Text("REVIEW")
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // MARK: - Specializations
                        if let specializations = garage.specializations, !specializations.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Specializations")
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(specializations, id: \.self) { spec in
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                            
                                            Text(spec)
                                                .font(.system(size: 13))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        }
                        
                        // MARK: - Reviews Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                SectionHeader(title: "Community Reviews")
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("SEE ALL")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                }
                            }
                            
                            VStack(spacing: 16) {
                                ForEach(sampleReviews) { review in
                                    ReviewItemView(review: review)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Section Header Component
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.black)
    }
}

// MARK: - Review Item Component
struct ReviewItemView: View {
    let review: GarageReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)).opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Text(review.avatarInitials)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(review.date)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                    }
                }
            }
            
            Text(review.reviewText)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
                .lineSpacing(1.2)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        GarageDetailView(garage: sampleGarages[0])
    }
}
