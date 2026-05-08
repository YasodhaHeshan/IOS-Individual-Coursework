import SwiftUI
import MapKit

struct GarageMapView: View {
    @Environment(\.dismiss) var dismiss
    let garage: Garage
    @State private var position: MapCameraPosition = .automatic
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Map
            if let location = garage.garageLocation {
                Map(position: $position) {
                    Annotation(garage.name, coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "mappin.circle.fill")
                                .appFont(size: 24)
                                .foregroundColor(.white)
                        }
                    }
                }
                .onAppear {
                    position = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    VStack(spacing: 12) {
                        Image(systemName: "location.slash")
                            .appFont(size: 40)
                            .foregroundColor(.gray)
                        
                        Text("Location Not Available")
                            .appFont(size: 14, weight: .semibold)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Header
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .appFont(size: 16, weight: .semibold)
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(garage.name)
                            .appFont(size: 14, weight: .semibold)
                            .foregroundColor(.black)
                        
                        if let address = garage.address {
                            Text(address)
                                .appFont(size: 11)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(16)
                
                Spacer()
            }
            
            // Bottom Actions
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: { openAppleMaps() }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.triangle.turn.up.right")
                                .appFont(size: 14, weight: .semibold)
                            
                            Text("SHOW DIRECTIONS")
                                .appFont(size: 13, weight: .semibold)
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(Color.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        .cornerRadius(10)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: { openGoogleMaps() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                    .appFont(size: 12, weight: .semibold)
                                
                                Text("Google Maps")
                                    .appFont(size: 12, weight: .semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(8)
                        }
                        
                        Button(action: { copyLocation() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.on.doc")
                                    .appFont(size: 12, weight: .semibold)
                                
                                Text("Copy Location")
                                    .appFont(size: 12, weight: .semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(16)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .alert("Success", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func openAppleMaps() {
        guard let location = garage.garageLocation else {
            alertMessage = "Location not available"
            showAlert = true
            return
        }
        
        let placemark = MKPlacemark(
            coordinate: location.coordinate,
            addressDictionary: nil
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = garage.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func openGoogleMaps() {
        guard let latitude = garage.latitude, let longitude = garage.longitude else {
            alertMessage = "Location not available"
            showAlert = true
            return
        }
        
        let urlString = "https://maps.google.com/?q=\(latitude),\(longitude)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            alertMessage = "Google Maps not available. Please use Apple Maps instead."
            showAlert = true
        }
    }
    
    private func copyLocation() {
        guard let latitude = garage.latitude, let longitude = garage.longitude else {
            alertMessage = "Location not available"
            showAlert = true
            return
        }
        
        let locationString = "\(latitude), \(longitude)"
        UIPasteboard.general.string = locationString
        
        alertMessage = "Location coordinates copied to clipboard"
        showAlert = true
    }
}

#Preview {
    GarageMapView(garage: sampleGarages[0])
}
