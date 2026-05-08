import XCTest
import CoreLocation
@testable import IOS_Induvidual_Coursework

final class GarageModelTests: XCTestCase {

    // MARK: - Helpers

    private func makeGarage(
        latitude: Double? = nil,
        longitude: Double? = nil,
        rating: Double? = nil,
        distance: String? = nil
    ) -> Garage {
        Garage(
            name: "Test Garage",
            category: "Auto Repair",
            location: "Colombo",
            latitude: latitude,
            longitude: longitude,
            rating: rating,
            priceRange: "LKR 10,000+",
            imageName: "garage1",
            isVerified: true,
            distance: distance
        )
    }

    // MARK: - garageLocation computed property

    func test_garageLocation_withValidCoordinates_returnsLocation() {
        let garage = makeGarage(latitude: 6.9271, longitude: 80.7789)
        XCTAssertNotNil(garage.garageLocation)
    }

    func test_garageLocation_withValidCoordinates_hasCorrectLatitude() {
        let garage = makeGarage(latitude: 6.9271, longitude: 80.7789)
        XCTAssertEqual(garage.garageLocation?.coordinate.latitude ?? 0, 6.9271, accuracy: 0.0001)
    }

    func test_garageLocation_withValidCoordinates_hasCorrectLongitude() {
        let garage = makeGarage(latitude: 6.9271, longitude: 80.7789)
        XCTAssertEqual(garage.garageLocation?.coordinate.longitude ?? 0, 80.7789, accuracy: 0.0001)
    }

    func test_garageLocation_withNilLatitude_returnsNil() {
        let garage = makeGarage(latitude: nil, longitude: 80.7789)
        XCTAssertNil(garage.garageLocation)
    }

    func test_garageLocation_withNilLongitude_returnsNil() {
        let garage = makeGarage(latitude: 6.9271, longitude: nil)
        XCTAssertNil(garage.garageLocation)
    }

    func test_garageLocation_withBothNil_returnsNil() {
        let garage = makeGarage(latitude: nil, longitude: nil)
        XCTAssertNil(garage.garageLocation)
    }

    // MARK: - Identifiable / Hashable

    func test_garage_twoInstancesWithSameId_areEqual() {
        let id = UUID()
        let g1 = Garage(id: id, name: "A", category: "Auto", location: "Colombo",
                        priceRange: "LKR 5,000+", imageName: "img", isVerified: false)
        let g2 = Garage(id: id, name: "A", category: "Auto", location: "Colombo",
                        priceRange: "LKR 5,000+", imageName: "img", isVerified: false)
        XCTAssertEqual(g1.id, g2.id)
    }

    func test_garage_twoInstancesWithDifferentIds_areDifferent() {
        let g1 = makeGarage()
        let g2 = makeGarage()
        XCTAssertNotEqual(g1.id, g2.id)
    }

    // MARK: - Sample data sanity

    func test_sampleGarages_hasExpectedCount() {
        XCTAssertEqual(sampleGarages.count, 4)
    }

    func test_sampleGarages_allHaveNonEmptyNames() {
        for garage in sampleGarages {
            XCTAssertFalse(garage.name.isEmpty, "Garage \(garage.id) has an empty name")
        }
    }

    func test_sampleGarages_allHaveValidCoordinates() {
        for garage in sampleGarages {
            XCTAssertNotNil(garage.garageLocation,
                            "\(garage.name) should have valid coordinates")
        }
    }

    func test_sampleGarages_allHaveRatings() {
        for garage in sampleGarages {
            XCTAssertNotNil(garage.rating, "\(garage.name) should have a rating")
        }
    }

    func test_sampleGarages_ratingsAreBetween0and5() {
        for garage in sampleGarages {
            if let rating = garage.rating {
                XCTAssertGreaterThanOrEqual(rating, 0.0)
                XCTAssertLessThanOrEqual(rating, 5.0)
            }
        }
    }
}
