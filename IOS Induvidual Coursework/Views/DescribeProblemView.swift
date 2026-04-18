import SwiftUI

struct DescribeProblemView: View {
    @State private var description: String = ""
    @State private var detailedDescription: String = ""
    @State private var selectedUrgency: String = "OTHERS"
    @Environment(\.presentationMode) var presentationMode
    
    let urgencyOptions = ["URGENT", "OTHERS"]
    
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
                            
                            // Urgency Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("TOTAL EXPERIENCE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    ForEach(urgencyOptions, id: \.self) { option in
                                        VStack(spacing: 4) {
                                            Image(systemName: getUrgencyIcon(for: option))
                                                .font(.system(size: 24))
                                                .foregroundColor(selectedUrgency == option ? .white : .gray)
                                            
                                            Text(option)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(selectedUrgency == option ? .white : .gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .background(selectedUrgency == option ? Color.orange : Color.white)
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedUrgency = option
                                        }
                                    }
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
    
    private func getUrgencyIcon(for option: String) -> String {
        switch option {
        case "URGENT":
            return "exclamationmark.circle.fill"
        case "OTHERS":
            return "checkmark.circle.fill"
        default:
            return "circle"
        }
    }
}

#Preview {
    DescribeProblemView()
}
