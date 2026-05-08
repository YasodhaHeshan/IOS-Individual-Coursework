import XCTest
@testable import IOS_Induvidual_Coursework

@MainActor
final class OnboardingViewModelTests: XCTestCase {

    var sut: OnboardingViewModel!

    override func setUp() {
        super.setUp()
        sut = OnboardingViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func test_initialPage_isEstimateCosts() {
        XCTAssertEqual(sut.currentPage, .estimateCosts)
    }

    func test_initialPage_isNotLastPage() {
        XCTAssertFalse(sut.isLastPage)
    }

    // MARK: - nextPage

    func test_nextPage_fromFirstPage_advancesToSecondPage() {
        sut.nextPage()
        XCTAssertEqual(sut.currentPage, .compareGarages)
    }

    func test_nextPage_fromSecondPage_advancesToThirdPage() {
        sut.currentPage = .compareGarages
        sut.nextPage()
        XCTAssertEqual(sut.currentPage, .smartDiagnosis)
    }

    func test_nextPage_fromLastPage_staysOnLastPage() {
        sut.currentPage = .smartDiagnosis
        sut.nextPage()
        XCTAssertEqual(sut.currentPage, .smartDiagnosis)
    }

    func test_nextPage_throughAllPages_endsOnLast() {
        let allPages = OnboardingPage.allCases
        for _ in 0..<allPages.count + 2 {
            sut.nextPage()
        }
        XCTAssertEqual(sut.currentPage, allPages.last)
    }

    // MARK: - isLastPage

    func test_isLastPage_onFirstPage_returnsFalse() {
        sut.currentPage = .estimateCosts
        XCTAssertFalse(sut.isLastPage)
    }

    func test_isLastPage_onMiddlePage_returnsFalse() {
        sut.currentPage = .compareGarages
        XCTAssertFalse(sut.isLastPage)
    }

    func test_isLastPage_onLastPage_returnsTrue() {
        sut.currentPage = .smartDiagnosis
        XCTAssertTrue(sut.isLastPage)
    }

    // MARK: - pageIndicator

    func test_pageIndicator_onFirstPage_returns1of3() {
        sut.currentPage = .estimateCosts
        XCTAssertEqual(sut.pageIndicator.current, 1)
        XCTAssertEqual(sut.pageIndicator.total, 3)
    }

    func test_pageIndicator_onSecondPage_returns2of3() {
        sut.currentPage = .compareGarages
        XCTAssertEqual(sut.pageIndicator.current, 2)
        XCTAssertEqual(sut.pageIndicator.total, 3)
    }

    func test_pageIndicator_onLastPage_returns3of3() {
        sut.currentPage = .smartDiagnosis
        XCTAssertEqual(sut.pageIndicator.current, 3)
        XCTAssertEqual(sut.pageIndicator.total, 3)
    }

    func test_pageIndicator_totalAlwaysEquals3() {
        for page in OnboardingPage.allCases {
            sut.currentPage = page
            XCTAssertEqual(sut.pageIndicator.total, OnboardingPage.allCases.count)
        }
    }
}

// MARK: - OnboardingPage enum tests

final class OnboardingPageTests: XCTestCase {

    func test_allCasesCount_isThree() {
        XCTAssertEqual(OnboardingPage.allCases.count, 3)
    }

    func test_rawValues_areConsecutiveStartingFromZero() {
        XCTAssertEqual(OnboardingPage.estimateCosts.rawValue, 0)
        XCTAssertEqual(OnboardingPage.compareGarages.rawValue, 1)
        XCTAssertEqual(OnboardingPage.smartDiagnosis.rawValue, 2)
    }

    func test_titles_matchExpected() {
        XCTAssertEqual(OnboardingPage.estimateCosts.title, "Estimate Costs")
        XCTAssertEqual(OnboardingPage.compareGarages.title, "Compare Garages")
        XCTAssertEqual(OnboardingPage.smartDiagnosis.title, "Smart Diagnosis")
    }

    func test_titles_areNonEmpty() {
        for page in OnboardingPage.allCases {
            XCTAssertFalse(page.title.isEmpty, "\(page) should have a non-empty title")
        }
    }

    func test_descriptions_areNonEmpty() {
        for page in OnboardingPage.allCases {
            XCTAssertFalse(page.description.isEmpty, "\(page) should have a non-empty description")
        }
    }

    func test_icons_areNonEmpty() {
        for page in OnboardingPage.allCases {
            XCTAssertFalse(page.icon.isEmpty, "\(page) should have a non-empty icon name")
        }
    }

    func test_icons_matchExpected() {
        XCTAssertEqual(OnboardingPage.estimateCosts.icon, "wrench.and.screwdriver.fill")
        XCTAssertEqual(OnboardingPage.compareGarages.icon, "building.2.fill")
        XCTAssertEqual(OnboardingPage.smartDiagnosis.icon, "waveform.circle.fill")
    }
}
