import Foundation

struct RepairRequest: Identifiable, Codable {
    var id: String
    var userId: String
    var vehicleMake: String
    var vehicleModel: String
    var vehicleYear: Int
    var damageCategory: String
    var description: String
    var imageURLs: [String]
    var predictedCost: Double?
    var predictedConfidence: Double?
    var selectedGarageId: String?
    var status: String
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case vehicleMake = "vehicle_make"
        case vehicleModel = "vehicle_model"
        case vehicleYear = "vehicle_year"
        case damageCategory = "damage_category"
        case description
        case imageURLs = "image_urls"
        case predictedCost = "predicted_cost"
        case predictedConfidence = "predicted_confidence"
        case selectedGarageId = "selected_garage_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}

extension RepairRequest {
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        userId = try c.decode(String.self, forKey: .userId)
        vehicleMake = try c.decode(String.self, forKey: .vehicleMake)
        vehicleModel = try c.decode(String.self, forKey: .vehicleModel)
        vehicleYear = try c.decode(Int.self, forKey: .vehicleYear)
        damageCategory = (try? c.decodeIfPresent(String.self, forKey: .damageCategory)) ?? ""
        description = (try? c.decodeIfPresent(String.self, forKey: .description)) ?? ""
        imageURLs = (try? c.decodeIfPresent([String].self, forKey: .imageURLs)) ?? []
        predictedCost = try? c.decodeIfPresent(Double.self, forKey: .predictedCost)
        predictedConfidence = try? c.decodeIfPresent(Double.self, forKey: .predictedConfidence)
        selectedGarageId = try? c.decodeIfPresent(String.self, forKey: .selectedGarageId)
        status = (try? c.decodeIfPresent(String.self, forKey: .status)) ?? "pending"
        createdAt = try? c.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try? c.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
}

extension RepairCostEstimate {
    init(from request: RepairRequest) {
        let midCost = request.predictedCost ?? 22_000
        let confidence = request.predictedConfidence ?? 0.75
        let partsCostVal = Int(midCost * 0.6)
        let laborCostVal = Int(midCost * 0.4)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        totalCost = String(format: "%.1fK", midCost / 1000)
        currency = "LKR"
        priceLabel = "Repair • LKR • \(request.vehicleMake)"
        partsName = request.damageCategory.isEmpty ? "General Parts" : "\(request.damageCategory) Parts"
        partsCost = "LKR \(formatter.string(from: NSNumber(value: partsCostVal)) ?? "\(partsCostVal)")"
        laborName = "Labor"
        laborCost = "LKR \(formatter.string(from: NSNumber(value: laborCostVal)) ?? "\(laborCostVal)")"
        laborHours = "Estimated 2-4 hours"
        analysisSummary = [
            AnalysisPoint(
                title: "Saved Estimate",
                description: "Category: \(request.damageCategory), confidence: \(Int(confidence * 100))%."
            ),
            AnalysisPoint(
                title: "Vehicle Context",
                description: "Estimate for \(request.vehicleYear) \(request.vehicleMake) \(request.vehicleModel) based on service patterns."
            )
        ]
        garageComparison = [
            GarageInfo(name: "Nearby Verified Garages", icon: "building.2.fill"),
            GarageInfo(name: "Top Rated Specialists", icon: "wrench.and.screwdriver.fill")
        ]
        rawCost = midCost
        rawConfidence = confidence
    }
}

struct RepairCostEstimate {
    let totalCost: String
    let currency: String
    let priceLabel: String
    let partsName: String
    let partsCost: String
    let laborName: String
    let laborCost: String
    let laborHours: String
    let analysisSummary: [AnalysisPoint]
    let garageComparison: [GarageInfo]
    var rawCost: Double = 0
    var rawConfidence: Double = 0.75
    
    struct AnalysisPoint {
        let title: String
        let description: String
    }
    
    struct GarageInfo {
        let name: String
        let icon: String
    }
}
