import Foundation
import Combine
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var preferredLocation = ""
    @Published var profileImageURL: String?
    @Published var notificationsEnabled = false
    @Published var language = "English"
    @Published var measurementUnit = "Metric"
    @Published var textSize = "Default"
    @Published var boldTextEnabled = false
    @Published var reduceMotionEnabled = false
    @Published var hapticFeedbackEnabled = true
    @Published var darkModeEnabled = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let authService = AuthService.shared
    private let supabaseService = SupabaseService.shared
    
    init() {
        loadCurrentUserData()
    }
    
    func loadCurrentUserData() {
        if let user = authService.currentUser {
            self.fullName = user.fullName ?? ""
            self.email = user.email
            self.phone = user.phone ?? ""
            self.preferredLocation = user.preferredLocation ?? ""
            self.profileImageURL = user.profileImageURL
        }
        
        // Load saved preferences from UserDefaults
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.language = UserDefaults.standard.string(forKey: "language") ?? "English"
        self.measurementUnit = UserDefaults.standard.string(forKey: "measurementUnit") ?? "Metric"
        self.textSize = UserDefaults.standard.string(forKey: "textSize") ?? "Default"
        self.boldTextEnabled = UserDefaults.standard.bool(forKey: "boldTextEnabled")
        self.reduceMotionEnabled = UserDefaults.standard.bool(forKey: "reduceMotionEnabled")
        self.hapticFeedbackEnabled = UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true
        self.darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }
    
    func fetchProfileFromServer() async {
        guard let userId = authService.currentUser?.id else { return }
        do {
            let user = try await supabaseService.getUserProfile(userId: userId)
            authService.currentUser = user
            self.fullName = user.fullName ?? ""
            self.email = user.email
            self.phone = user.phone ?? ""
            self.preferredLocation = user.preferredLocation ?? ""
            self.profileImageURL = user.profileImageURL
        } catch {
            // Silently fall back to cached data on network failure
        }
    }

    func updateProfile(fullName: String, phone: String, location: String, profileImage: UIImage? = nil) async {
        guard let userId = authService.currentUser?.id else {
            errorMessage = "User not authenticated"
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        // Upload image separately so a failure doesn't block saving text fields
        var uploadedImageURL: String? = nil
        var imageUploadError: String? = nil
        if let image = profileImage {
            do {
                uploadedImageURL = try await supabaseService.uploadProfileImage(image, userId: userId)
            } catch {
                imageUploadError = "Photo could not be saved. Please check your Supabase storage bucket settings."
            }
        }

        do {
            try await supabaseService.updateUserProfile(
                userId: userId,
                fullName: fullName,
                phone: phone,
                preferredLocation: location,
                profileImageURL: uploadedImageURL
            )

            if var user = authService.currentUser {
                user.fullName = fullName
                user.phone = phone
                user.preferredLocation = location
                if let url = uploadedImageURL { user.profileImageURL = url }
                authService.currentUser = user
                authService.saveSession(user: user)
            }

            self.fullName = fullName
            self.phone = phone
            self.preferredLocation = location
            if let url = uploadedImageURL { self.profileImageURL = url }

            isLoading = false
            if let imgErr = imageUploadError {
                errorMessage = imgErr
            } else {
                successMessage = "Profile updated successfully"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.successMessage = nil
                }
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func saveNotificationPreference(_ enabled: Bool) {
        notificationsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
        
        // If you want to persist this to Supabase as well
        Task {
            guard let userId = authService.currentUser?.id else { return }
            try? await supabaseService.updateUserPreferences(
                userId: userId,
                notificationsEnabled: enabled,
                language: language,
                measurementUnit: measurementUnit
            )
        }
    }
    
    func saveLanguagePreference(_ lang: String) {
        language = lang
        UserDefaults.standard.set(lang, forKey: "language")
        
        Task {
            guard let userId = authService.currentUser?.id else { return }
            try? await supabaseService.updateUserPreferences(
                userId: userId,
                notificationsEnabled: notificationsEnabled,
                language: lang,
                measurementUnit: measurementUnit
            )
        }
    }
    
    func saveMeasurementUnitPreference(_ unit: String) {
        measurementUnit = unit
        UserDefaults.standard.set(unit, forKey: "measurementUnit")

        Task {
            guard let userId = authService.currentUser?.id else { return }
            try? await supabaseService.updateUserPreferences(
                userId: userId,
                notificationsEnabled: notificationsEnabled,
                language: language,
                measurementUnit: unit
            )
        }
    }

    // MARK: - Accessibility Preferences

    func saveTextSizePreference(_ size: String) {
        textSize = size
        AccessibilitySettings.shared.textSize = size
    }

    func saveBoldTextPreference(_ enabled: Bool) {
        boldTextEnabled = enabled
        AccessibilitySettings.shared.boldTextEnabled = enabled
    }

    func saveReduceMotionPreference(_ enabled: Bool) {
        reduceMotionEnabled = enabled
        AccessibilitySettings.shared.reduceMotionEnabled = enabled
    }

    func saveHapticFeedbackPreference(_ enabled: Bool) {
        hapticFeedbackEnabled = enabled
        AccessibilitySettings.shared.hapticFeedbackEnabled = enabled
    }

    func saveDarkModePreference(_ enabled: Bool) {
        darkModeEnabled = enabled
        AccessibilitySettings.shared.darkModeEnabled = enabled
    }
}
