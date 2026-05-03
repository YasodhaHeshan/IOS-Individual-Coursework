import SwiftUI

struct DescribeProblemView: View {
    @State private var description: String = ""
    @State private var detailedDescription: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var isFormValid: Bool {
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !detailedDescription.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
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
                                Text("Report Issue")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Describe the problem.")
                                    .font(.system(size: 28, weight: .bold))
                                
                                Text("Explain your vehicle problem in detail to get an accurate diagnostic result.")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            // Brief Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("BRIEF DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("Describe your issue...", text: $description, axis: .vertical)
                                    .lineLimit(3...5)
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Detailed Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("DETAILED DESCRIPTION")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                TextField("E.g. Ping noises heard when accelerating or hear bumper sounds...", text: $detailedDescription, axis: .vertical)
                                    .lineLimit(3...5)
                                    .font(.system(size: 14, weight: .regular))
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Visual Evidence
                            VStack(alignment: .leading, spacing: 12) {
                                Text("VISUAL EVIDENCE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)

                                HStack(spacing: 12) {
                                    Button {
                                        // Upload action placeholder
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(systemName: "camera")
                                                .font(.system(size: 22, weight: .semibold))
                                                .foregroundColor(.gray)
                                            Text("UPLOAD")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 90)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                                .foregroundColor(Color.gray.opacity(0.4))
                                        )
                                    }

                                    HStack(spacing: 10) {
                                        Image(systemName: "info.circle.fill")
                                            .foregroundColor(.orange)
                                        Text("Clear photos help us provide 95% accurate estimates")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 90)
                                    .padding(.horizontal, 12)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    
                    // Calculate Cost Button
                    VStack(spacing: 12) {
                        NavigationLink(destination: ReportIssueView()) {
                            HStack(spacing: 8) {
                                Text("Calculate Cost")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isFormValid ? Color.orange : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid)
                        
                        Text("By continuing, you agree to our terms of service")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, TabBarLayout.bottomClearance)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

#Preview {
    DescribeProblemView()
}
