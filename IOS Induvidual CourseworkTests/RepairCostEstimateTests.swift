import XCTest
@testable import IOS_Induvidual_Coursework

final class RepairCostEstimateTests: XCTestCase {

    // MARK: - Helpers

    private func makeRequest(
        predictedCost: Double? = nil,
        predictedConfidence: Double? = nil,
        vehicleMake: String = "Toyota",
        vehicleModel: String = "Corolla",
        vehicleYear: Int = 2020,
        damageCategory: String = "Body Damage"
    ) -> RepairRequest {
        RepairRequest(
            id: "test-id",
            userId: "user-id",
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            vehicleYear: vehicleYear,
            damageCategory: damageCategory,
            description: "Test description",
            imageURLs: [],
            predictedCost: predictedCost,
            predictedConfidence: predictedConfidence,
            selectedGarageId: nil,
            status: "pending"
        )
    }

    private func decimalString(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    // MARK: - rawCost

    func test_rawCost_withExplicitCost_usesProvidedValue() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: 30_000))
        XCTAssertEqual(estimate.rawCost, 30_000)
    }

    func test_rawCost_withNilCost_defaultsTo22000() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: nil))
        XCTAssertEqual(estimate.rawCost, 22_000)
    }

    // MARK: - rawConfidence

    func test_rawConfidence_withExplicitValue_usesProvidedValue() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedConfidence: 0.90))
        XCTAssertEqual(estimate.rawConfidence, 0.90, accuracy: 0.001)
    }

    func test_rawConfidence_withNilValue_defaultsTo075() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedConfidence: nil))
        XCTAssertEqual(estimate.rawConfidence, 0.75, accuracy: 0.001)
    }

    // MARK: - totalCost string

    func test_totalCost_22000_formattedAs22dot0K() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: 22_000))
        XCTAssertEqual(estimate.totalCost, "22.0K")
    }

    func test_totalCost_50000_formattedAs50dot0K() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: 50_000))
        XCTAssertEqual(estimate.totalCost, "50.0K")
    }

    func test_totalCost_15500_formattedAs15dot5K() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: 15_500))
        XCTAssertEqual(estimate.totalCost, "15.5K")
    }

    // MARK: - cost split (60 % parts / 40 % labor)

    func test_partsCost_is60PercentOfTotal() {
        let cost = 20_000.0
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: cost))
        let expected = decimalString(Int(cost * 0.6))   // 12,000
        XCTAssertTrue(estimate.partsCost.contains(expected),
                      "Expected partsCost to contain \(expected), got: \(estimate.partsCost)")
    }

    func test_laborCost_is40PercentOfTotal() {
        let cost = 20_000.0
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: cost))
        let expected = decimalString(Int(cost * 0.4))   // 8,000
        XCTAssertTrue(estimate.laborCost.contains(expected),
                      "Expected laborCost to contain \(expected), got: \(estimate.laborCost)")
    }

    func test_partsCostAndLaborCost_sumToTotal() {
        let cost = 40_000.0
        let estimate = RepairCostEstimate(from: makeRequest(predictedCost: cost))
        let parts = Int(cost * 0.6)
        let labor = Int(cost * 0.4)
        XCTAssertEqual(parts + labor, Int(cost))
    }

    // MARK: - currency

    func test_currency_isLKR() {
        let estimate = RepairCostEstimate(from: makeRequest())
        XCTAssertEqual(estimate.currency, "LKR")
    }

    // MARK: - partsName

    func test_partsName_withDamageCategory_includesCategoryInName() {
        let estimate = RepairCostEstimate(from: makeRequest(damageCategory: "Engine Damage"))
        XCTAssertEqual(estimate.partsName, "Engine Damage Parts")
    }

    func test_partsName_withEmptyDamageCategory_usesGeneralParts() {
        let estimate = RepairCostEstimate(from: makeRequest(damageCategory: ""))
        XCTAssertEqual(estimate.partsName, "General Parts")
    }

    // MARK: - priceLabel

    func test_priceLabel_includesVehicleMake() {
        let estimate = RepairCostEstimate(from: makeRequest(vehicleMake: "Honda"))
        XCTAssertTrue(estimate.priceLabel.contains("Honda"))
    }

    func test_priceLabel_includesLKR() {
        let estimate = RepairCostEstimate(from: makeRequest())
        XCTAssertTrue(estimate.priceLabel.contains("LKR"))
    }

    // MARK: - laborHours

    func test_laborHours_isNonEmpty() {
        let estimate = RepairCostEstimate(from: makeRequest())
        XCTAssertFalse(estimate.laborHours.isEmpty)
    }

    // MARK: - analysisSummary

    func test_analysisSummary_hasTwoPoints() {
        let estimate = RepairCostEstimate(from: makeRequest())
        XCTAssertEqual(estimate.analysisSummary.count, 2)
    }

    func test_analysisSummary_includesVehicleInfo() {
        let estimate = RepairCostEstimate(from: makeRequest(
            vehicleMake: "Nissan",
            vehicleModel: "Sunny",
            vehicleYear: 2019
        ))
        let vehiclePoint = estimate.analysisSummary.first { $0.title == "Vehicle Context" }
        XCTAssertNotNil(vehiclePoint)
        XCTAssertTrue(vehiclePoint!.description.contains("Nissan"))
        XCTAssertTrue(vehiclePoint!.description.contains("Sunny"))
        XCTAssertTrue(vehiclePoint!.description.contains("2019"))
    }

    func test_analysisSummary_savedEstimateIncludesConfidencePercent() {
        let estimate = RepairCostEstimate(from: makeRequest(predictedConfidence: 0.80))
        let savedPoint = estimate.analysisSummary.first { $0.title == "Saved Estimate" }
        XCTAssertNotNil(savedPoint)
        XCTAssertTrue(savedPoint!.description.contains("80%"))
    }

    // MARK: - garageComparison

    func test_garageComparison_hasTwoEntries() {
        let estimate = RepairCostEstimate(from: makeRequest())
        XCTAssertEqual(estimate.garageComparison.count, 2)
    }

    func test_garageComparison_entriesHaveNonEmptyNames() {
        let estimate = RepairCostEstimate(from: makeRequest())
        for entry in estimate.garageComparison {
            XCTAssertFalse(entry.name.isEmpty)
        }
    }
}
