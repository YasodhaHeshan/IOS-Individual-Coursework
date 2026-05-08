import Foundation
import Combine

@MainActor
final class AppFlowViewModel: ObservableObject {
    @Published var currentScreen: AppScreen = .splash

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe auth state and route accordingly
        AuthService.shared.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                if isAuthenticated {
                    // Only auto-navigate to home when restoring a session from splash.
                    // Login/SignUp screens use their own callbacks so the user sees onboarding.
                    if self.currentScreen == .splash {
                        self.currentScreen = .home
                    }
                } else {
                    self.currentScreen = .login
                }
            }
            .store(in: &cancellables)
    }

    func startSplashTimer() {
        Task {
            try? await Task.sleep(for: .seconds(1.6))
            // After splash, route based on authentication state
            if AuthService.shared.isAuthenticated {
                currentScreen = .home
            } else {
                currentScreen = .login
            }
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

    func goToHome() {
        currentScreen = .home
    }
}
