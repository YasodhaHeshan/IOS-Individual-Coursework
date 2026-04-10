import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showPassword = false

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func login() {
    }

    func forgotPassword() {
    }
}
