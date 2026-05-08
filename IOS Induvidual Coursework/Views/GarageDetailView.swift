import SwiftUI
import MapKit

struct GarageDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) private var openURL
    @StateObject private var garageService = GarageService.shared
    let garage: Garage
    @State private var showMapView = false
    @State private var reviews: [GarageReview] = []
    @State private var isLoadingReviews = false
    @State private var hasFetchedReviews = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header Image
                    ZStack(alignment: .topLeading) {
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
                                            .appFont(size: 80)
                                            .foregroundColor(.gray.opacity(0.5))
                                    }
                                @unknown default:
                                    ZStack {
                                        Color.gray.opacity(0.2)
                                    }
                                }
                            }
                            .frame(height: 240)
                        } else {
                            ZStack {
                                Color.gray.opacity(0.2)
                                Image(systemName: "building.2.fill")
                                    .appFont(size: 80)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .frame(height: 240)
                        }
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .appFont(size: 16, weight: .semibold)
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .clipShape(Circle())
                        }
                        .padding(16)
                    }
                    
                    VStack(spacing: 20) {
                        // MARK: - Garage Info
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Text(garage.name)
                                    .appFont(size: 22, weight: .bold)
                                    .foregroundColor(.primary)
                                
                                if garage.isVerified {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .appFont(size: 14)
                                        Text("VERIFIED")
                                            .appFont(size: 11, weight: .semibold)
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
                                        Image(systemName: index < Int(garage.rating ?? 0.0) ? "star.fill" : "star")
                                            .appFont(size: 14)
                                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String(format: "%.1f", garage.rating ?? 0.0))
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.primary)
                                    
                                    Text("(\(garage.reviewCount) Reviews)")
                                        .appFont(size: 12)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Description
                            if let description = garage.description {
                                Text(description)
                                    .appFont(size: 13, weight: .regular)
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
                                        .appFont(size: 18)
                                        .foregroundColor(.gray)
                                    
                                    if let address = garage.address {
                                        Text(address)
                                            .appFont(size: 13)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "clock.circle.fill")
                                        .appFont(size: 18)
                                        .foregroundColor(.gray)
                                    
                                    if let hours = garage.openHours {
                                        Text(hours)
                                            .appFont(size: 13)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "phone.circle.fill")
                                        .appFont(size: 18)
                                        .foregroundColor(.gray)
                                    
                                    if let phone = garage.phone {
                                        Text(phone)
                                            .appFont(size: 13)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Action Buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                showMapView = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "location.fill")
                                        .appFont(size: 14, weight: .semibold)

                                    Text("GET DIRECTIONS")
                                        .appFont(size: 13, weight: .semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                .cornerRadius(8)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    if let phone = garage.phone, let url = URL(string: "tel://\(phone.filter { $0.isNumber })") {
                                        openURL(url)
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "phone.fill")
                                            .appFont(size: 14, weight: .semibold)
                                        
                                        Text("CONTACT")
                                            .appFont(size: 13, weight: .semibold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                }
                                
                                NavigationLink(destination: WriteReviewView(selectedGarage: garage.name)) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "pencil")
                                            .appFont(size: 14, weight: .semibold)
                                        
                                        Text("REVIEW")
                                            .appFont(size: 13, weight: .semibold)
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
                                                .appFont(size: 14)
                                                .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                            
                                            Text(spec)
                                                .appFont(size: 13)
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
                                if isLoadingReviews {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                            }

                            if hasFetchedReviews && reviews.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .appFont(size: 32)
                                        .foregroundColor(.gray.opacity(0.4))
                                    Text("No reviews yet")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.gray)
                                    Text("Be the first to share your experience.")
                                        .appFont(size: 12)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                            } else {
                                VStack(spacing: 16) {
                                    ForEach(hasFetchedReviews ? reviews : sampleReviews) { review in
                                        ReviewItemView(review: review)
                                    }
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
        .sheet(isPresented: $showMapView) {
            GarageMapView(garage: garage)
        }
        .task {
            await loadReviews()
        }
    }

    private func loadReviews() async {
        isLoadingReviews = true
        reviews = (try? await SupabaseService.shared.fetchGarageReviews(garageName: garage.name)) ?? []
        isLoadingReviews = false
        hasFetchedReviews = true
    }
}

// MARK: - Section Header Component
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .appFont(size: 14, weight: .semibold)
            .foregroundColor(.primary)
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
                        .appFont(size: 12, weight: .semibold)
                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.authorName)
                        .appFont(size: 13, weight: .semibold)
                        .foregroundColor(.primary)
                    
                    Text(review.date)
                        .appFont(size: 11)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                            .appFont(size: 10)
                            .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                    }
                }
            }
            
            Text(review.reviewText)
                .appFont(size: 12, weight: .regular)
                .foregroundColor(.gray)
                .lineSpacing(1.2)
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        GarageDetailView(garage: sampleGarages[0])
    }
}
