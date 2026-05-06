//
//  AuthService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let biometricService = BiometricAuthService()
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = AuthService()
    
    private init() {
        restoreSession()
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String, fullName: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let user = try await supabaseService.signUp(email: email, password: password)
            
            if supabaseService.hasActiveSession {
                try await supabaseService.createUserProfile(
                    userId: user.id,
                    email: email,
                    fullName: fullName
                )

                DispatchQueue.main.async {
                    self.currentUser = user
                    self.saveSession(user: user)
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.currentUser = nil
                    self.isAuthenticated = false
                    self.errorMessage = "Account created. Please verify your email and then log in."
                    self.isLoading = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let user = try await supabaseService.signIn(email: email, password: password)
            
            // Save credentials securely for biometric login
            biometricService.saveCredentials(email: email, password: password)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.saveSession(user: user)
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signInWithBiometric(email: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            // Authenticate with biometric
            try await biometricService.authenticateWithBiometric()
            
            // Retrieve saved password
            guard let password = biometricService.retrieveCredentials(email: email) else {
                throw NSError(domain: "BiometricAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Credentials not found"])
            }
            
            // Sign in with retrieved credentials
            let user = try await supabaseService.signIn(email: email, password: password)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signOut() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            try await supabaseService.signOut()
            
            if let email = currentUser?.email {
                biometricService.deleteSavedCredentials(email: email)
            }
            
            DispatchQueue.main.async {
                self.clearSession()
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func resetPassword(email: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            try await supabaseService.resetPassword(email: email)
            
            DispatchQueue.main.async {
                self.errorMessage = "Password reset link sent to your email"
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Session Management
    
    private func restoreSession() {
        DispatchQueue.main.async {
            // Restore from secure storage or UserDefaults
            if let userJson = UserDefaults.standard.string(forKey: "currentUser"),
               let data = userJson.data(using: .utf8),
               let user = try? JSONDecoder().decode(User.self, from: data) {
                self.currentUser = user
                self.isAuthenticated = true
            }
        }
    }
    
    func saveSession(user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            let json = String(data: encoded, encoding: .utf8)
            UserDefaults.standard.set(json, forKey: "currentUser")
        }
    }
    
    func clearSession() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        currentUser = nil
        isAuthenticated = false
    }
}

// MARK: - User Model

struct User: Codable, Identifiable {
    let id: String
    let email: String
    var fullName: String?
    var phone: String?
    var profileImageURL: String?
    var preferredLocation: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case phone
        case profileImageURL = "profile_image_url"
        case preferredLocation = "preferred_location"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
