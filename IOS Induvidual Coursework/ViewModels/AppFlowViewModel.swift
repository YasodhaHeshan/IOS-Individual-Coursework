import Foundation
import Combine

@MainActor
final class AppFlowViewModel: ObservableObject {
    @Published var currentScreen: AppScreen = .splash

    func startSplashTimer() {
        Task {
            try? await Task.sleep(for: .seconds(1.6))
            currentScreen = .login
        }
    }

    func goToSignUp() {
        currentScreen = .signUp
    }

    func goToLogin() {
        currentScreen = .login
    }

    func goToOnboarding() {
        currentScreen = .onboarding
    }
}
