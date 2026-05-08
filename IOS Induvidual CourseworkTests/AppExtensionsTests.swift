import XCTest
@testable import IOS_Induvidual_Coursework

final class AppExtensionsTests: XCTestCase {

    // MARK: - String.isValidEmail

    func test_isValidEmail_standardAddress_returnsTrue() {
        XCTAssertTrue("user@example.com".isValidEmail)
    }

    func test_isValidEmail_withPlusTag_returnsTrue() {
        XCTAssertTrue("user.name+tag@domain.co.uk".isValidEmail)
    }

    func test_isValidEmail_withSubdomain_returnsTrue() {
        XCTAssertTrue("user@mail.example.com".isValidEmail)
    }

    func test_isValidEmail_empty_returnsFalse() {
        XCTAssertFalse("".isValidEmail)
    }

    func test_isValidEmail_noAtSign_returnsFalse() {
        XCTAssertFalse("notanemail".isValidEmail)
    }

    func test_isValidEmail_noTLD_returnsFalse() {
        XCTAssertFalse("user@domain".isValidEmail)
    }

    func test_isValidEmail_missingLocalPart_returnsFalse() {
        XCTAssertFalse("@domain.com".isValidEmail)
    }

    func test_isValidEmail_missingDomain_returnsFalse() {
        XCTAssertFalse("user@".isValidEmail)
    }

    func test_isValidEmail_withSpaces_returnsFalse() {
        XCTAssertFalse("user @example.com".isValidEmail)
    }

    func test_isValidEmail_singleCharTLD_returnsFalse() {
        XCTAssertFalse("user@domain.c".isValidEmail)
    }

    // MARK: - String.isValidPassword

    func test_isValidPassword_exactlyEightChars_returnsTrue() {
        XCTAssertTrue("12345678".isValidPassword)
    }

    func test_isValidPassword_moreThanEightChars_returnsTrue() {
        XCTAssertTrue("strongpassword123".isValidPassword)
    }

    func test_isValidPassword_sevenChars_returnsFalse() {
        XCTAssertFalse("1234567".isValidPassword)
    }

    func test_isValidPassword_empty_returnsFalse() {
        XCTAssertFalse("".isValidPassword)
    }

    // MARK: - String.isValidPhone

    func test_isValidPhone_sriLankanWithCountryCode_returnsTrue() {
        XCTAssertTrue("+94771234567".isValidPhone)
    }

    func test_isValidPhone_localFormat_returnsTrue() {
        XCTAssertTrue("0771234567".isValidPhone)
    }

    func test_isValidPhone_empty_returnsFalse() {
        XCTAssertFalse("".isValidPhone)
    }

    func test_isValidPhone_letters_returnsFalse() {
        XCTAssertFalse("abcdefghij".isValidPhone)
    }

    // MARK: - Double.distanceFormatted

    func test_distanceFormatted_under1000_showsMeters() {
        XCTAssertEqual(500.0.distanceFormatted, "500 m")
    }

    func test_distanceFormatted_exactly999_showsMeters() {
        XCTAssertEqual(999.0.distanceFormatted, "999 m")
    }

    func test_distanceFormatted_exactly1000_showsKm() {
        XCTAssertEqual(1000.0.distanceFormatted, "1.0 km")
    }

    func test_distanceFormatted_1500_showsKm() {
        XCTAssertEqual(1500.0.distanceFormatted, "1.5 km")
    }

    func test_distanceFormatted_2300_showsKm() {
        XCTAssertEqual(2300.0.distanceFormatted, "2.3 km")
    }

    // MARK: - Comparable.clamped

    func test_clamped_valueWithinRange_returnsValue() {
        XCTAssertEqual(5.clamped(to: 0...10), 5)
    }

    func test_clamped_valueAtLowerBound_returnsLowerBound() {
        XCTAssertEqual(0.clamped(to: 0...10), 0)
    }

    func test_clamped_valueAtUpperBound_returnsUpperBound() {
        XCTAssertEqual(10.clamped(to: 0...10), 10)
    }

    func test_clamped_valueBelowRange_returnsLowerBound() {
        XCTAssertEqual((-5).clamped(to: 0...10), 0)
    }

    func test_clamped_valueAboveRange_returnsUpperBound() {
        XCTAssertEqual(20.clamped(to: 0...10), 10)
    }

    func test_clamped_doubleWithinRange_returnsValue() {
        XCTAssertEqual(3.5.clamped(to: 0.0...5.0), 3.5, accuracy: 0.001)
    }

    // MARK: - Array.togglePresence

    func test_togglePresence_elementNotPresent_addsElement() {
        var array = [TestItem(id: "1"), TestItem(id: "2")]
        let newItem = TestItem(id: "3")
        array.togglePresence(of: newItem)
        XCTAssertEqual(array.count, 3)
        XCTAssertTrue(array.contains(newItem))
    }

    func test_togglePresence_elementPresent_removesElement() {
        let target = TestItem(id: "2")
        var array = [TestItem(id: "1"), target]
        array.togglePresence(of: target)
        XCTAssertEqual(array.count, 1)
        XCTAssertFalse(array.contains(target))
    }

    func test_togglePresence_toggleTwice_restoresOriginalCount() {
        var array = [TestItem(id: "1")]
        let item = TestItem(id: "2")
        array.togglePresence(of: item)
        array.togglePresence(of: item)
        XCTAssertEqual(array.count, 1)
    }

    // MARK: - Array.contains (Identifiable)

    func test_arrayContains_elementWithSameId_returnsTrue() {
        let item = TestItem(id: "abc")
        let array = [item]
        XCTAssertTrue(array.contains(item))
    }

    func test_arrayContains_elementWithDifferentId_returnsFalse() {
        let array = [TestItem(id: "abc")]
        XCTAssertFalse(array.contains(TestItem(id: "xyz")))
    }
}

private struct TestItem: Identifiable {
    let id: String
}
