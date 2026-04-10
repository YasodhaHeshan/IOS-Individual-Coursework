//
//  ContentView.swift
//  IOS Induvidual Coursework
//
//  Created on 10/04/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showSplash)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                showSplash = false
            }
        }
    }
}

private struct SplashView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 16) {
                    AppLogo(size: 74, iconSize: 30)

                    VStack(spacing: 4) {
                        Text("RepairCost LK")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("AUTOMOTIVE PRECISION")
                            .font(.footnote.weight(.medium))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Text("EST. MODERN • VEHICLE DIAGNOSTIC SUITE")
                    .font(.caption2.weight(.medium))
                    .tracking(1)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 24)
        }
    }
}

private struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

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
                            TextField("name@example.com", text: $email)
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
                                Button("FORGOT?") {}
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(Color.orange)
                            }

                            HStack {
                                if showPassword {
                                    TextField("••••••••", text: $password)
                                        .textContentType(.password)
                                } else {
                                    SecureField("••••••••", text: $password)
                                        .textContentType(.password)
                                }

                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            )
                        }
                    }

                    Button {} label: {
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
                        Button("Sign up") {}
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

private struct AppLogo: View {
    let size: CGFloat
    let iconSize: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color.orange.opacity(0.95), Color.orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
    }
}

private struct BottomInfoCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(subtitle)
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}

#Preview {
    ContentView()
}
