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

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func toggleConfirmPasswordVisibility() {
        showConfirmPassword.toggle()
    }

    func signUp() {
    }
}
