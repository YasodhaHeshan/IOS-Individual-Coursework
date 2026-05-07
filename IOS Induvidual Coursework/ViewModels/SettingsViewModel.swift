import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var preferredLocation = ""
    @Published var notificationsEnabled = false
    @Published var language = "English"
    @Published var measurementUnit = "Metric"
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
        }
        
        // Load saved preferences from UserDefaults
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.language = UserDefaults.standard.string(forKey: "language") ?? "English"
        self.measurementUnit = UserDefaults.standard.string(forKey: "measurementUnit") ?? "Metric"
    }
    
    func updateProfile(fullName: String, phone: String, location: String) async {
        guard let userId = authService.currentUser?.id else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            try await supabaseService.updateUserProfile(
                userId: userId,
                fullName: fullName,
                phone: phone,
                preferredLocation: location
            )
            
            // Update local state - create a new User with updated values
            if var user = authService.currentUser {
                user.fullName = fullName
                user.phone = phone
                user.preferredLocation = location
                authService.currentUser = user
            }
            
            self.fullName = fullName
            self.phone = phone
            self.preferredLocation = location
            
            isLoading = false
            successMessage = "Profile updated successfully"
            
            // Clear success message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.successMessage = nil
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
}
