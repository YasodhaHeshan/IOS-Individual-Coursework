import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showPassword = false
    @Published var showConfirmPassword = false
    @Published var localErrorMessage: String?

    private let authService = AuthService.shared

    var isLoading: Bool {
        authService.isLoading
    }

    var errorMessage: String? {
        localErrorMessage ?? authService.errorMessage
    }

    var canSubmit: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !isLoading
    }

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func toggleConfirmPasswordVisibility() {
        showConfirmPassword.toggle()
    }

    func signUp() async {
        localErrorMessage = nil

        let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !trimmedName.isEmpty else {
            localErrorMessage = "Please enter your full name"
            return
        }

        guard trimmedEmail.contains("@"), trimmedEmail.contains(".") else {
            localErrorMessage = "Please enter a valid email address"
            return
        }

        guard password.count >= 8 else {
            localErrorMessage = "Password must be at least 8 characters"
            return
        }

        guard password == confirmPassword else {
            localErrorMessage = "Passwords do not match"
            return
        }

        await authService.signUp(email: trimmedEmail, password: password, fullName: trimmedName)
    }
}
