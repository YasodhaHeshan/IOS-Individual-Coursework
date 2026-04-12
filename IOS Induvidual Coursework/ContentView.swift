//
//  ContentView.swift
//  IOS Induvidual Coursework
//
//  Created on 10/04/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var flowViewModel = AppFlowViewModel()

    var body: some View {
        ZStack {
            switch flowViewModel.currentScreen {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .login:
                LoginView(
                    onSignUpTap: flowViewModel.goToSignUp,
                    onLoginSuccess: flowViewModel.goToOnboarding
                )
                .transition(.opacity)
            case .signUp:
                SignUpView(
                    onCancel: flowViewModel.goToLogin,
                    onLoginTap: flowViewModel.goToLogin
                )
                .transition(.opacity)
            case .onboarding:
                OnboardingView(onComplete: flowViewModel.goToHome)
                    .transition(.opacity)
            case .home:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: flowViewModel.currentScreen)
        .onAppear {
            flowViewModel.startSplashTimer()
        }
    }
}

#Preview {
    ContentView()
}
