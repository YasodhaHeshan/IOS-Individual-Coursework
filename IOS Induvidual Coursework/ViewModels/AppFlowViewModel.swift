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
                    // If authenticated, go to home unless onboarding is explicitly required
                    if self.currentScreen == .splash || self.currentScreen == .login || self.currentScreen == .signUp {
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
