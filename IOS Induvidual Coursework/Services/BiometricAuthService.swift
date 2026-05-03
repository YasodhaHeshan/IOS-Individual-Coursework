//
//  BiometricAuthService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine
import LocalAuthentication

class BiometricAuthService: ObservableObject {
    @Published var isBiometricAvailable = false
    @Published var biometricType: BiometricType = .none
    
    enum BiometricType {
        case none
        case faceID
        case touchID
    }
    
    enum BiometricError: Error {
        case unavailable
        case notEnrolled
        case userCancel
        case userFallback
        case biometryLockout
        case biometryNotAvailable
        case unknown(Error)
    }
    
    init() {
        checkBiometricAvailability()
    }
    
    func checkBiometricAvailability() {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            self.isBiometricAvailable = false
            self.biometricType = .none
            return
        }
        
        self.isBiometricAvailable = true
        
        if context.biometryType == .faceID {
            self.biometricType = .faceID
        } else if context.biometryType == .touchID {
            self.biometricType = .touchID
        } else {
            self.biometricType = .none
        }
    }
    
    func authenticateWithBiometric() async throws {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error = error {
                throw BiometricError.unknown(error)
            }
            throw BiometricError.unavailable
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to access your account"
            )
            
            if !success {
                throw BiometricError.userCancel
            }
        } catch let error as LAError {
            switch error.code {
            case .userCancel:
                throw BiometricError.userCancel
            case .userFallback:
                throw BiometricError.userFallback
            case .biometryLockout:
                throw BiometricError.biometryLockout
            case .biometryNotAvailable:
                throw BiometricError.biometryNotAvailable
            default:
                throw BiometricError.unknown(error)
            }
        } catch {
            throw BiometricError.unknown(error)
        }
    }
    
    func saveCredentials(email: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: password.data(using: .utf8) ?? Data()
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func retrieveCredentials(email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return password
    }
    
    func deleteSavedCredentials(email: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
