import XCTest
@testable import IOS_Induvidual_Coursework

@MainActor
final class GaragesViewModelTests: XCTestCase {

    var sut: GaragesViewModel!

    override func setUp() {
        super.setUp()
        sut = GaragesViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - filterGarages — search text

    func test_filterGarages_emptySearchText_returnsAllGarages() {
        sut.searchText = ""
        XCTAssertEqual(sut.filteredGarages.count, sut.garages.count)
    }

    func test_filterGarages_matchingName_returnsMatchingGarages() {
        sut.searchText = "Precision"
        XCTAssertEqual(sut.filteredGarages.count, 1)
        XCTAssertEqual(sut.filteredGarages.first?.name, "Precision Motors")
    }

    func test_filterGarages_caseInsensitiveMatchOnName_returnsResult() {
        sut.searchText = "precision"
        XCTAssertFalse(sut.filteredGarages.isEmpty)
        XCTAssertEqual(sut.filteredGarages.first?.name, "Precision Motors")
    }

    func test_filterGarages_matchingCategory_returnsCorrectGarages() {
        sut.searchText = "Quick Service"
        XCTAssertTrue(sut.filteredGarages.allSatisfy { $0.category == "Quick Service" })
    }

    func test_filterGarages_matchingLocation_returnsGaragesInLocation() {
        // All sample garages are in Colombo
        sut.searchText = "Colombo"
        XCTAssertEqual(sut.filteredGarages.count, sut.garages.count)
    }

    func test_filterGarages_noMatch_returnsEmpty() {
        sut.searchText = "NonExistentGarageXYZ"
        XCTAssertTrue(sut.filteredGarages.isEmpty)
    }

    func test_filterGarages_clearSearchText_restoresAllGarages() {
        sut.searchText = "Precision"
        XCTAssertEqual(sut.filteredGarages.count, 1)
        sut.searchText = ""
        XCTAssertEqual(sut.filteredGarages.count, sut.garages.count)
    }

    // MARK: - sortByTab — nearby

    func test_sortByTab_nearby_sortsAscendingByDistance() {
        sut.selectedTab = "nearby"
        sut.sortByTab()
        let distances: [Double] = sut.filteredGarages.compactMap { garage in
            guard let raw = garage.distance?.replacingOccurrences(of: " km", with: "") else { return nil }
            return Double(raw)
        }
        let isSortedAscending = zip(distances, distances.dropFirst()).allSatisfy { $0 <= $1 }
        XCTAssertTrue(isSortedAscending)
    }

    func test_sortByTab_nearby_closestGarageIsFirst() {
        sut.selectedTab = "nearby"
        sut.sortByTab()
        // "Swift Fix Sri Lanka" has distance "0.9 km" — closest
        XCTAssertEqual(sut.filteredGarages.first?.name, "Swift Fix Sri Lanka")
    }

    // MARK: - sortByTab — topRated

    func test_sortByTab_topRated_sortsDescendingByRating() {
        sut.selectedTab = "topRated"
        sut.sortByTab()
        let ratings = sut.filteredGarages.compactMap { $0.rating }
        let isSortedDescending = zip(ratings, ratings.dropFirst()).allSatisfy { $0 >= $1 }
        XCTAssertTrue(isSortedDescending)
    }

    func test_sortByTab_topRated_lowestRatedGarageIsLast() {
        sut.selectedTab = "topRated"
        sut.sortByTab()
        // "Swift Fix Sri Lanka" has rating 3.9 — lowest
        XCTAssertEqual(sut.filteredGarages.last?.name, "Swift Fix Sri Lanka")
    }

    // MARK: - setTab

    func test_setTab_updatesSelectedTab() {
        sut.setTab("topRated")
        XCTAssertEqual(sut.selectedTab, "topRated")
    }

    func test_setTab_topRated_appliesSortImmediately() {
        sut.setTab("topRated")
        let ratings = sut.filteredGarages.compactMap { $0.rating }
        let isSortedDescending = zip(ratings, ratings.dropFirst()).allSatisfy { $0 >= $1 }
        XCTAssertTrue(isSortedDescending)
    }

    func test_setTab_nearby_appliesSortImmediately() {
        sut.setTab("nearby")
        let distances: [Double] = sut.filteredGarages.compactMap { garage in
            guard let raw = garage.distance?.replacingOccurrences(of: " km", with: "") else { return nil }
            return Double(raw)
        }
        let isSortedAscending = zip(distances, distances.dropFirst()).allSatisfy { $0 <= $1 }
        XCTAssertTrue(isSortedAscending)
    }
}
