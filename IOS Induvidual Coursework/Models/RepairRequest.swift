import Foundation

struct RepairRequest {
    var vehicleType: String = ""
    var vehicleBrand: String = ""
    var vehicleModel: String = ""
    var manufacturingYear: Int?
    var problemDescription: String = ""
    var detailedDescription: String = ""
    var urgency: UrgencyLevel = .others
    
    enum UrgencyLevel: String, CaseIterable {
        case urgent = "URGENT"
        case others = "OTHERS"
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
    
    struct AnalysisPoint {
        let title: String
        let description: String
    }
    
    struct GarageInfo {
        let name: String
        let icon: String
    }
}
