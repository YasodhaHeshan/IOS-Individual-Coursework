import Foundation

struct SparePart: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let compatibility: String
    let price: Double
    let type: SparePartType
    let icon: String
    
    enum SparePartType {
        case brakePads
        case engineOil
        case airFilter
        case batteryPad
        case sparkPlug
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
        name: "Front Set - Toyota Prius",
        category: "Brake Pads",
        compatibility: "OEM ORIGINAL",
        price: 18500,
        type: .brakePads,
        icon: "square.fill"
    ),
    SparePart(
        name: "Premium Aftermarket",
        category: "Brake Pads",
        compatibility: "PREMIUM AFTERMARKET",
        price: 12200,
        type: .brakePads,
        icon: "square.fill"
    ),
    SparePart(
        name: "Economy Choice",
        category: "Brake Pads",
        compatibility: "ECONOMY CHOICE",
        price: 7800,
        type: .brakePads,
        icon: "bag.fill"
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
