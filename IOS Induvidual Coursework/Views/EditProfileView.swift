import SwiftUI
import PhotosUI
import UIKit

struct EditProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editedFullName = ""
    @State private var editedPhone = ""
    @State private var editedLocation = ""
    @State private var isSaving = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var formError: String?
    
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
                                    if let selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color(red: 0.2, green: 0.2, blue: 0.3))
                                            .frame(width: 100, height: 100)

                                        Text(getInitials(editedFullName))
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }

                                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
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
                            if let formError {
                                Text(formError)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.red.opacity(0.06))
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
                            if !isFormValid {
                                formError = "Please enter a full name and a valid phone number (if provided)."
                                return
                            }
                            formError = nil
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
                    .onChange(of: selectedPhotoItem) { newItem in
                        guard let newItem else { return }
                        Task {
                            await loadSelectedImage(from: newItem)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
        .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
        .onAppear {
            editedFullName = viewModel.fullName
            editedPhone = viewModel.phone
            editedLocation = viewModel.preferredLocation
        }
    }
    

    private var isFormValid: Bool {
        !editedFullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (editedPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isValidPhone(editedPhone))
    }

    private func isValidPhone(_ phone: String) -> Bool {
        let digits = phone.filter { $0.isNumber }
        return digits.count >= 7 && digits.count <= 15
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

    private func loadSelectedImage(from item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                formError = "Unable to load selected image"
                return
            }

            await MainActor.run {
                selectedImage = image
                formError = nil
            }
        } catch {
            await MainActor.run {
                formError = error.localizedDescription
            }
        }
    }
}

#Preview {
    EditProfileView()
}
