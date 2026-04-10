import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    let onSignUpTap: () -> Void

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
                            .font(.system(size: 36, weight: .heavy, design: .rounded))

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
                                    viewModel.forgotPassword()
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

                    Button {
                        viewModel.login()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Login")
                                .font(.headline.weight(.semibold))
                            Image(systemName: "arrow.right")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .background(Color.orange, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    Button {} label: {
                        HStack(spacing: 10) {
                            Image(systemName: "faceid")
                            Text("Sign in with Face ID")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .tint(.primary)

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
                            title: "SECURE CLOUD",
                            subtitle: "INFRASTRUCTURE"
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
    }
}

#Preview {
    LoginView(onSignUpTap: {})
}
