import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: OnboardingPage = .estimateCosts

    func nextPage() {
        let allPages = OnboardingPage.allCases
        if let currentIndex = allPages.firstIndex(of: currentPage),
           currentIndex < allPages.count - 1 {
            currentPage = allPages[currentIndex + 1]
        }
    }

    func skipOnboarding() {
    }

    func getStarted() {
    }

    var isLastPage: Bool {
        currentPage == OnboardingPage.allCases.last
    }

    var pageIndicator: (current: Int, total: Int) {
        (currentPage.rawValue + 1, OnboardingPage.allCases.count)
    }
}
