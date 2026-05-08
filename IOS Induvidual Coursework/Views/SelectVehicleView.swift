import SwiftUI

struct SelectVehicleView: View {
    @State private var selectedVehicleType: String = ""
    @State private var selectedBrand: String = ""
    @State private var selectedModel: String = ""
    @State private var selectedYear: String = ""
    @State private var showBrandPicker = false
    @State private var showModelPicker = false
    @State private var showYearPicker = false
    @Environment(\.presentationMode) var presentationMode
    
    let vehicleTypes = ["Car", "Motorcycle", "Truck", "Van"]
    let brands = ["Honda", "Toyota", "BMW", "Mercedes", "Ford", "Hyundai", "Nissan", "Suzuki"]
    let models = ["Civic", "Accord", "CR-V", "Pilot", "City", "Odyssey"]
    let years = Array(2000...2026).map { String($0) }.reversed()
    
    var isFormValid: Bool {
        !selectedVehicleType.isEmpty && !selectedBrand.isEmpty && 
        !selectedModel.isEmpty && !selectedYear.isEmpty
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
                                    .appFont(size: 16, weight: .semibold)
                                Text("RepairCost LK")
                                    .appFont(size: 14, weight: .semibold)
                            }
                            .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            // Title
                            VStack(alignment: .leading, spacing: 8) {
                                Text("CONFIGURATION")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                Text("Select Vehicle")
                                    .appFont(size: 28, weight: .bold)
                                
                                Text("Select your vehicle type and provide details for a more accurate diagnostic and service quote.")
                                    .appFont(size: 14, weight: .regular)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 20)
                            
                            // Vehicle Type Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("VEHICLE TYPE")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 12) {
                                    ForEach(vehicleTypes, id: \.self) { type in
                                        VStack(spacing: 8) {
                                            Image(systemName: getVehicleIcon(for: type))
                                                .appFont(size: 28)
                                                .foregroundColor(selectedVehicleType == type ? .white : .gray)
                                            
                                            Text(type)
                                                .appFont(size: 10, weight: .semibold)
                                                .foregroundColor(selectedVehicleType == type ? .white : .gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 80)
                                        .background(selectedVehicleType == type ? Color.orange : Color(uiColor: .secondarySystemGroupedBackground))
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedVehicleType = type
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Vehicle Brand
                            VStack(alignment: .leading, spacing: 12) {
                                Text("VEHICLE BRAND")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(selectedBrand.isEmpty ? "Select Brand" : selectedBrand)
                                        .appFont(size: 16, weight: .regular)
                                        .foregroundColor(selectedBrand.isEmpty ? .gray : .primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(10)
                                .onTapGesture {
                                    showBrandPicker.toggle()
                                }
                                
                                if showBrandPicker {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(brands, id: \.self) { brand in
                                            HStack {
                                                Text(brand)
                                                    .appFont(size: 16, weight: .regular)
                                                Spacer()
                                                if selectedBrand == brand {
                                                    Image(systemName: "checkmark")
                                                        .appFont(size: 14, weight: .semibold)
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .onTapGesture {
                                                selectedBrand = brand
                                                showBrandPicker = false
                                            }
                                            
                                            if brand != brands.last {
                                                Divider()
                                                    .padding(.horizontal, 16)
                                            }
                                        }
                                    }
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Vehicle Model
                            VStack(alignment: .leading, spacing: 12) {
                                Text("VEHICLE MODEL")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(selectedModel.isEmpty ? "Select Model" : selectedModel)
                                        .appFont(size: 16, weight: .regular)
                                        .foregroundColor(selectedModel.isEmpty ? .gray : .primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(10)
                                .onTapGesture {
                                    showModelPicker.toggle()
                                }
                                
                                if showModelPicker {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(models, id: \.self) { model in
                                            HStack {
                                                Text(model)
                                                    .appFont(size: 16, weight: .regular)
                                                Spacer()
                                                if selectedModel == model {
                                                    Image(systemName: "checkmark")
                                                        .appFont(size: 14, weight: .semibold)
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .onTapGesture {
                                                selectedModel = model
                                                showModelPicker = false
                                            }
                                            
                                            if model != models.last {
                                                Divider()
                                                    .padding(.horizontal, 16)
                                            }
                                        }
                                    }
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Manufacturing Year
                            VStack(alignment: .leading, spacing: 12) {
                                Text("MANUFACTURING YEAR")
                                    .appFont(size: 12, weight: .semibold)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text(selectedYear.isEmpty ? "E.g. 2022" : selectedYear)
                                        .appFont(size: 16, weight: .regular)
                                        .foregroundColor(selectedYear.isEmpty ? .gray : .primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .appFont(size: 14, weight: .semibold)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(10)
                                .onTapGesture {
                                    showYearPicker.toggle()
                                }
                                
                                if showYearPicker {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(years, id: \.self) { year in
                                            HStack {
                                                Text(year)
                                                    .appFont(size: 16, weight: .regular)
                                                Spacer()
                                                if selectedYear == year {
                                                    Image(systemName: "checkmark")
                                                        .appFont(size: 14, weight: .semibold)
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .onTapGesture {
                                                selectedYear = year
                                                showYearPicker = false
                                            }
                                            
                                            if year != years.last {
                                                Divider()
                                                    .padding(.horizontal, 16)
                                            }
                                        }
                                    }
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Info Card
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .appFont(size: 20)
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("By selecting your vehicle")
                                        .appFont(size: 12, weight: .semibold)
                                    
                                    Text("You have a more compatible parts and specialist connected to any garage.")
                                        .appFont(size: 12, weight: .regular)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(red: 1.0, green: 0.95, blue: 0.9))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    
                    // Continue Button
                    VStack(spacing: 12) {
                        NavigationLink(
                            destination: DescribeProblemView(
                                vehicleType: selectedVehicleType,
                                vehicleMake: selectedBrand,
                                vehicleModel: selectedModel,
                                vehicleYear: Int(selectedYear) ?? Calendar.current.component(.year, from: Date())
                            )
                        ) {
                            HStack(spacing: 8) {
                                Text("Continue")
                                Image(systemName: "arrow.right")
                            }
                            .appFont(size: 16, weight: .semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(isFormValid ? Color.orange : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .disabled(!isFormValid)
                        
                        Text("By continuing, you agree to our terms of service")
                            .appFont(size: 11, weight: .regular)
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
    
    private func getVehicleIcon(for type: String) -> String {
        switch type {
        case "Car":
            return "car.fill"
        case "Motorcycle":
            return "scooter"
        case "Truck":
            return "truck.box.fill"
        case "Van":
            return "van.fill"
        default:
            return "car.fill"
        }
    }
}

#Preview {
    SelectVehicleView()
}
