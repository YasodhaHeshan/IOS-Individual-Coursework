import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editedFullName = ""
    @State private var editedPhone = ""
    @State private var editedLocation = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Edit Profile")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Avatar
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.2, green: 0.2, blue: 0.3))
                                        .frame(width: 100, height: 100)
                                    
                                    Text(getInitials(editedFullName))
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Button(action: {}) {
                                    Text("Change Photo")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.orange)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            
                            // Form Fields
                            VStack(spacing: 16) {
                                // Full Name
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Full Name")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter your full name", text: $editedFullName)
                                        .font(.system(size: 16, weight: .regular))
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                // Email (Read-only)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    Text(viewModel.email)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                
                                // Phone
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Phone Number")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter your phone number", text: $editedPhone)
                                        .font(.system(size: 16, weight: .regular))
                                        .keyboardType(.phonePad)
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                // Preferred Location
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Preferred Location")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    TextField("e.g., Colombo, Western Province", text: $editedLocation)
                                        .font(.system(size: 16, weight: .regular))
                                        .padding(12)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Error/Success Messages
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            if let successMessage = viewModel.successMessage {
                                Text(successMessage)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Save Button
                    VStack(spacing: 10) {
                        Button(action: {
                            Task {
                                isSaving = true
                                await viewModel.updateProfile(
                                    fullName: editedFullName,
                                    phone: editedPhone,
                                    location: editedLocation
                                )
                                isSaving = false
                            }
                        }) {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            } else {
                                Text("Save Changes")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .foregroundColor(.white)
                            }
                        }
                        .background(Color.orange)
                        .cornerRadius(12)
                        .disabled(isSaving)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(uiColor: .systemGroupedBackground))
                }
            }
        }
        .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
        .onAppear {
            editedFullName = viewModel.fullName
            editedPhone = viewModel.phone
            editedLocation = viewModel.preferredLocation
        }
    }
    
    private func getInitials(_ name: String) -> String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if let first = components.first {
            return String(first.prefix(2))
        }
        return "U"
    }
}

#Preview {
    EditProfileView()
}
