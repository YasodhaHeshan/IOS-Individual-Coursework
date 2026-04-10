import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    let onCancel: () -> Void
    let onLoginTap: () -> Void

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        header
                        formCard
                        termsRow
                        Spacer(minLength: 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
                }

                VStack(spacing: 10) {
                    Button {
                        viewModel.signUp()
                    } label: {
                        Text("Sign Up")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.orange)
                            )
                    }

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                        Button("Log In") {
                            onLoginTap()
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.orange)
                    }
                    .font(.footnote)

                    Text("REPAIR LK ARCHITECTURE V2.4.0")
                        .font(.caption2)
                        .tracking(1)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 14)
                .background(Color(uiColor: .systemGroupedBackground))
            }
        }
    }

    private var topBar: some View {
        ZStack {
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .foregroundStyle(.secondary)

                Spacer()
            }

            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundStyle(Color.orange)
                Text("Sign Up")
                    .font(.headline.weight(.semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Create Account")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)

            Text("Join the network of transparency in vehicle repairs across Sri Lanka.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            inputField(
                title: "FULL NAME",
                placeholder: "Enter your full name",
                text: $viewModel.fullName,
                textContentType: .name
            )

            inputField(
                title: "EMAIL ADDRESS",
                placeholder: "example@domain.com",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                textContentType: .emailAddress
            )

            secureInputField(
                title: "PASSWORD",
                helper: "Min. 8 characters",
                text: $viewModel.password,
                isVisible: viewModel.showPassword,
                onToggleVisibility: viewModel.togglePasswordVisibility
            )

            secureInputField(
                title: "CONFIRM PASSWORD",
                helper: "Repeat password",
                text: $viewModel.confirmPassword,
                isVisible: viewModel.showConfirmPassword,
                onToggleVisibility: viewModel.toggleConfirmPasswordVisibility
            )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    private var termsRow: some View {
        HStack(alignment: .top, spacing: 8) {
            Button {} label: {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Text("By clicking \"Sign Up\", you agree to our Terms and Privacy Policy.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
    }

    private func inputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .tracking(1)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .autocorrectionDisabled(keyboardType == .emailAddress)
                .textContentType(textContentType)
                .foregroundStyle(.primary)
        }
    }

    private func secureInputField(
        title: String,
        helper: String,
        text: Binding<String>,
        isVisible: Bool,
        onToggleVisibility: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .tracking(1)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                if isVisible {
                    TextField(helper, text: text)
                        .textContentType(.newPassword)
                } else {
                    SecureField(helper, text: text)
                        .textContentType(.newPassword)
                }

                Button(action: onToggleVisibility) {
                    Image(systemName: isVisible ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    SignUpView(onCancel: {}, onLoginTap: {})
}
