import Foundation

struct SparePart: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let compatibility: String
    let price: Double
    let supplier: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case compatibility = "vehicle_compatibility"
        case price = "estimated_price"
        case supplier
        case imageURL = "image_url"
    }
    
    init(
        id: String = UUID().uuidString,
        name: String,
        category: String,
        compatibility: String,
        price: Double,
        supplier: String? = nil,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.compatibility = compatibility
        self.price = price
        self.supplier = supplier
        self.imageURL = imageURL
    }
}

struct PartComparison: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let minPrice: Double
    let maxPrice: Double
    let range: String
    let icon: String
}

let spareParts: [SparePart] = [
    SparePart(
        name: "Oil Filter - Toyota Corolla",
        category: "Filters",
        compatibility: "Toyota Corolla 2015-2022",
        price: 850,
        supplier: "Toyota Lanka Parts Co.",
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Oil_filter_2.jpg/320px-Oil_filter_2.jpg"
    ),
    SparePart(
        name: "Air Filter - Honda Civic",
        category: "Filters",
        compatibility: "Honda Civic 2016-2021",
        price: 1200,
        supplier: "Honda Parts Lanka",
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Luftfilter.jpg/320px-Luftfilter.jpg"
    ),
    SparePart(
        name: "Brake Pads - Front Set",
        category: "Brakes",
        compatibility: "Universal Fit",
        price: 3500,
        supplier: "AutoParts Lanka",
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Brake_pads.jpg/320px-Brake_pads.jpg"
    )
]

let trendingComparisons: [PartComparison] = [
    PartComparison(
        name: "Engine Oil (4L)",
        category: "Multiple Brands Available",
        minPrice: 9500,
        maxPrice: 24000,
        range: "Rs. 9.5k - 24k",
        icon: "square.fill"
    ),
    PartComparison(
        name: "Air Filter",
        category: "Washable vs Paper",
        minPrice: 2200,
        maxPrice: 8500,
        range: "Rs. 2.2k - 8.5k",
        icon: "diamond.fill"
    )
]

let partCategories = ["ALL PARTS", "ENGINE", "BRAKES", "FILTERS", "ELECTRICAL"]
