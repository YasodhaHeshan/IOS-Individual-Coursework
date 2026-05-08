import XCTest
@testable import IOS_Induvidual_Coursework

@MainActor
final class SignUpViewModelTests: XCTestCase {

    var sut: SignUpViewModel!

    override func setUp() {
        super.setUp()
        sut = SignUpViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - canSubmit

    func test_canSubmit_whenAllFieldsFilled_returnsTrue() {
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertTrue(sut.canSubmit)
    }

    func test_canSubmit_whenNameEmpty_returnsFalse() {
        sut.fullName = ""
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_whenNameIsOnlyWhitespace_returnsFalse() {
        sut.fullName = "   "
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_whenEmailEmpty_returnsFalse() {
        sut.fullName = "John Doe"
        sut.email = ""
        sut.password = "password123"
        sut.confirmPassword = "password123"
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_whenPasswordEmpty_returnsFalse() {
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = ""
        sut.confirmPassword = "password123"
        XCTAssertFalse(sut.canSubmit)
    }

    func test_canSubmit_whenConfirmPasswordEmpty_returnsFalse() {
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = ""
        XCTAssertFalse(sut.canSubmit)
    }

    // MARK: - togglePasswordVisibility

    func test_togglePasswordVisibility_startsHidden() {
        XCTAssertFalse(sut.showPassword)
    }

    func test_togglePasswordVisibility_firstToggle_showsPassword() {
        sut.togglePasswordVisibility()
        XCTAssertTrue(sut.showPassword)
    }

    func test_togglePasswordVisibility_secondToggle_hidesPassword() {
        sut.togglePasswordVisibility()
        sut.togglePasswordVisibility()
        XCTAssertFalse(sut.showPassword)
    }

    func test_toggleConfirmPasswordVisibility_startsHidden() {
        XCTAssertFalse(sut.showConfirmPassword)
    }

    func test_toggleConfirmPasswordVisibility_firstToggle_showsPassword() {
        sut.toggleConfirmPasswordVisibility()
        XCTAssertTrue(sut.showConfirmPassword)
    }

    // MARK: - signUp local validation

    func test_signUp_whenNameIsEmpty_setsNameError() async {
        sut.fullName = ""
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Please enter your full name")
    }

    func test_signUp_whenNameIsWhitespace_setsNameError() async {
        sut.fullName = "   "
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Please enter your full name")
    }

    func test_signUp_whenEmailLacksAtSign_setsEmailError() async {
        sut.fullName = "John Doe"
        sut.email = "invalidemail"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Please enter a valid email address")
    }

    func test_signUp_whenEmailLacksDot_setsEmailError() async {
        sut.fullName = "John Doe"
        sut.email = "user@nodot"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Please enter a valid email address")
    }

    func test_signUp_whenPasswordTooShort_setsPasswordError() async {
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = "1234567"        // 7 chars
        sut.confirmPassword = "1234567"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Password must be at least 8 characters")
    }

    func test_signUp_whenPasswordsDontMatch_setsMismatchError() async {
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "different456"
        await sut.signUp()
        XCTAssertEqual(sut.localErrorMessage, "Passwords do not match")
    }

    func test_signUp_validDataBeforeNetworkCall_clearsLocalError() async {
        // Set a previous error so we can confirm it is cleared
        sut.localErrorMessage = "Old error"
        sut.fullName = "John Doe"
        sut.email = "john@example.com"
        sut.password = "password123"
        sut.confirmPassword = "password123"
        // signUp() will clear localErrorMessage then attempt the network call.
        // We only verify the reset, not the network outcome.
        await sut.signUp()
        // localErrorMessage is nil immediately after the reset before any AuthService error.
        // If AuthService sets an error it goes through authService.errorMessage, not localErrorMessage.
        XCTAssertNil(sut.localErrorMessage)
    }
}
