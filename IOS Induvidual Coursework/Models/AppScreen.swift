import Foundation

enum AppScreen {
    case splash
    case login
    case signUp
    case onboarding
    case home
}

enum OnboardingPage: Int, CaseIterable {
    case estimateCosts = 0
    case compareGarages = 1
    case smartDiagnosis = 2

    var title: String {
        switch self {
        case .estimateCosts:
            return "Estimate Costs"
        case .compareGarages:
            return "Compare Garages"
        case .smartDiagnosis:
            return "Smart Diagnosis"
        }
    }

    var description: String {
        switch self {
        case .estimateCosts:
            return "Get accurate technical assessments tailored for the unique challenges of Sri Lankan roads and high-performance automotive standards."
        case .compareGarages:
            return "View detailed quotes, ratings, and facilities from verified service centers across Sri Lanka."
        case .smartDiagnosis:
            return "Our AI-driven engine analyzes local market data to provide the most accurate repair estimates in Sri Lanka. No more guessing."
        }
    }

    var icon: String {
        switch self {
        case .estimateCosts:
            return "wrench.and.screwdriver.fill"
        case .compareGarages:
            return "building.2.fill"
        case .smartDiagnosis:
            return "waveform.circle.fill"
        }
    }
}
