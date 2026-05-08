import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var authService = AuthService.shared
    @StateObject private var biometricService = BiometricAuthService()
    
    let onSignUpTap: () -> Void
    let onLoginSuccess: () -> Void
    
    @State private var showBiometricError = false
    @State private var biometricError: String = ""

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    AppLogo(size: 42, iconSize: 16)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("RepairCost LK")
                            .appFont(size: 36, weight: .heavy, design: .rounded)

                        Text("Precision estimates for Sri Lankan motorists.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("EMAIL ADDRESS")
                                .font(.caption2.weight(.semibold))
                                .tracking(1)
                                .foregroundStyle(.secondary)
                            TextField("name@example.com", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textContentType(.emailAddress)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("PASSWORD")
                                    .font(.caption2.weight(.semibold))
                                    .tracking(1)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button("FORGOT?") {
                                    Task {
                                        await authService.resetPassword(email: viewModel.email)
                                    }
                                }
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(Color.orange)
                            }

                            HStack {
                                if viewModel.showPassword {
                                    TextField("••••••••", text: $viewModel.password)
                                        .textContentType(.password)
                                } else {
                                    SecureField("••••••••", text: $viewModel.password)
                                        .textContentType(.password)
                                }

                                Button {
                                    viewModel.togglePasswordVisibility()
                                } label: {
                                    Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(viewModel.showPassword ? "Hide password" : "Show password")
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            )
                        }
                    }

                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }

                    Button {
                        Task {
                            await authService.signIn(email: viewModel.email, password: viewModel.password)
                            if authService.isAuthenticated {
                                onLoginSuccess()
                            }
                        }
                    } label: {
                        Group {
                            if authService.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                HStack {
                                    Spacer()
                                    Text("Login")
                                        .font(.headline.weight(.semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .background(Color.orange, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .disabled(authService.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)

                    if biometricService.isBiometricAvailable && hasStoredSession {
                        Button {
                            Task { await signInWithBiometric() }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: biometricService.biometricType == .faceID ? "faceid" : "touchid")
                                    .font(.title3)
                                Text("Sign in with \(biometricService.biometricType == .faceID ? "Face ID" : "Touch ID")")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        .disabled(authService.isLoading)
                    }

                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Button("Sign up") {
                            onSignUpTap()
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.orange)
                    }
                    .frame(maxWidth: .infinity)
                    .font(.footnote)

                    Spacer(minLength: 6)

                    HStack(spacing: 12) {
                        BottomInfoCard(
                            icon: "lock.shield",
                            title: "BEST SERVICE",
                            subtitle: "GUARANTEED"
                        )

                        BottomInfoCard(
                            icon: "bolt.fill",
                            title: "REAL-TIME",
                            subtitle: "DATA ENGINE"
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .onAppear {
            // Pre-fill email from stored session so Face ID button is visible
            if viewModel.email.isEmpty, let storedEmail = authService.currentUser?.email {
                viewModel.email = storedEmail
            }
        }
        .alert("Biometric Authentication", isPresented: $showBiometricError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(biometricError)
        }
    }
    
    // MARK: - Helper Methods

    private var hasStoredSession: Bool {
        authService.currentUser?.email != nil || !viewModel.email.isEmpty
    }

    private func signInWithBiometric() async {
        // Prefer the stored session email so the user doesn't need to type it
        let email = viewModel.email.isEmpty
            ? (authService.currentUser?.email ?? "")
            : viewModel.email

        guard !email.isEmpty else {
            biometricError = "Sign in with your password once first to enable Face ID."
            showBiometricError = true
            return
        }

        // AuthService handles the biometric prompt internally — do NOT call
        // biometricService.authenticateWithBiometric() here or Face ID fires twice.
        await authService.signInWithBiometric(email: email)

        if authService.isAuthenticated {
            onLoginSuccess()
        }
    }
}


#Preview {
    LoginView(onSignUpTap: {}, onLoginSuccess: {})
}
