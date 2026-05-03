import Foundation
import CoreLocation

struct Garage: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let category: String
    let location: String
    let latitude: Double?
    let longitude: Double?
    let rating: Double?
    let reviewCount: Int?
    let priceRange: String
    let imageName: String
    let imageURL: String?
    let isVerified: Bool
    let distance: String?
    
    // Detail page properties
    let description: String?
    let address: String?
    let openHours: String?
    let phone: String?
    let specializations: [String]?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case location
        case latitude
        case longitude
        case rating
        case reviewCount = "review_count"
        case priceRange = "price_range"
        case imageName = "image_name"
        case imageURL = "image_url"
        case isVerified = "is_verified"
        case distance
        case description
        case address
        case openHours = "open_hours"
        case phone
        case specializations
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // Computed property to get CLLocation
    var garageLocation: CLLocation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        location: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        rating: Double? = nil,
        reviewCount: Int? = nil,
        priceRange: String,
        imageName: String,
        imageURL: String? = nil,
        isVerified: Bool,
        distance: String? = nil,
        description: String? = nil,
        address: String? = nil,
        openHours: String? = nil,
        phone: String? = nil,
        specializations: [String]? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.reviewCount = reviewCount
        self.priceRange = priceRange
        self.imageName = imageName
        self.imageURL = imageURL
        self.isVerified = isVerified
        self.distance = distance
        self.description = description
        self.address = address
        self.openHours = openHours
        self.phone = phone
        self.specializations = specializations
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct GarageReview: Identifiable {
    let id: UUID = UUID()
    let authorName: String
    let rating: Double
    let date: String
    let reviewText: String
    let avatarInitials: String
}

// Sample data
let sampleGarages: [Garage] = [
    Garage(
        name: "Precision Motors",
        category: "Auto Repair",
        location: "Colombo",
        latitude: 6.9271,
        longitude: 80.7789,
        rating: 4.8,
        reviewCount: 156,
        priceRange: "LKR 15,500+",
        imageName: "garage1",
        isVerified: true,
        distance: "2.3 km",
        description: "Specializing in European and Japanese hybrids. Certified technician team with over 15 years of industry experience.",
        address: "No. 45, Duplication Road, Colombo",
        openHours: "Open - Close 6:00 PM",
        phone: "+94 11 XXXX XXXX",
        specializations: ["European Cars", "Japanese Hybrids", "Engine Repair", "Transmission Service"]
    ),
    Garage(
        name: "Apex Auto Care",
        category: "Service Center",
        location: "Colombo",
        latitude: 6.9271,
        longitude: 80.7700,
        rating: 4.2,
        reviewCount: 89,
        priceRange: "LKR 8,200+",
        imageName: "garage2",
        isVerified: false,
        distance: "1.8 km",
        description: "Full-service auto care center with modern diagnostics equipment.",
        address: "No. 23, Main Street, Colombo",
        openHours: "Open - Close 6:00 PM",
        phone: "+94 11 XXXX XXXX",
        specializations: ["Oil Changes", "Brake Service", "Tire Repair", "Diagnostics"]
    ),
    Garage(
        name: "Silver Star Garage",
        category: "Auto Repair",
        location: "Colombo",
        latitude: 6.9300,
        longitude: 80.7750,
        rating: 4.8,
        reviewCount: 112,
        priceRange: "LKR 20,000+",
        imageName: "garage3",
        isVerified: true,
        distance: "3.2 km",
        description: "Premium garage with certified technicians for luxury vehicles.",
        address: "No. 67, High Street, Colombo",
        openHours: "Open - Close 6:00 PM",
        phone: "+94 11 XXXX XXXX",
        specializations: ["Luxury Vehicles", "Engine Overhaul", "Custom Work"]
    ),
    Garage(
        name: "Swift Fix Sri Lanka",
        category: "Quick Service",
        location: "Colombo",
        latitude: 6.9250,
        longitude: 80.7650,
        rating: 3.9,
        reviewCount: 203,
        priceRange: "LKR 5,000+",
        imageName: "garage4",
        isVerified: false,
        distance: "0.9 km",
        description: "Fast and reliable auto repair services for all vehicle types.",
        address: "No. 89, Park Road, Colombo",
        openHours: "Open - Close 6:00 PM",
        phone: "+94 11 XXXX XXXX",
        specializations: ["Quick Repairs", "Maintenance", "Inspection", "Parts Replacement"]
    )
]

let sampleReviews: [GarageReview] = [
    GarageReview(
        authorName: "Amila Silva",
        rating: 5,
        date: "2 weeks ago",
        reviewText: "Trusted place for quick turnaround. The hybrid battery diagnostic was very thorough.",
        avatarInitials: "AS"
    ),
    GarageReview(
        authorName: "Kasun Perera",
        rating: 5,
        date: "1 week ago",
        reviewText: "Professional staff. A bit busy on weekends, so make sure you call ahead.",
        avatarInitials: "KP"
    )
]
