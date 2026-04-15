import Foundation

struct Garage: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: String
    let location: String
    let rating: Double
    let reviewCount: Int
    let priceRange: String
    let imageName: String
    let isVerified: Bool
    let distance: String?
    
    // Detail page properties
    let description: String?
    let address: String?
    let openHours: String?
    let phone: String?
    let specializations: [String]?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        location: String,
        rating: Double,
        reviewCount: Int,
        priceRange: String,
        imageName: String,
        isVerified: Bool,
        distance: String? = nil,
        description: String? = nil,
        address: String? = nil,
        openHours: String? = nil,
        phone: String? = nil,
        specializations: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.location = location
        self.rating = rating
        self.reviewCount = reviewCount
        self.priceRange = priceRange
        self.imageName = imageName
        self.isVerified = isVerified
        self.distance = distance
        self.description = description
        self.address = address
        self.openHours = openHours
        self.phone = phone
        self.specializations = specializations
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
        rating: 4.8,
        reviewCount: 156,
        priceRange: "LKR 15,500+",
        imageName: "garage1",
        isVerified: false,
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
        rating: 4.8,
        reviewCount: 112,
        priceRange: "LKR 21%",
        imageName: "garage3",
        isVerified: false,
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
