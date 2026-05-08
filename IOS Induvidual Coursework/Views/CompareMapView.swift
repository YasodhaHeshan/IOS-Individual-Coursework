import SwiftUI
import MapKit

struct CompareMapView: View {
    @Environment(\.dismiss) var dismiss
    let garages: [Garage]
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            if !garages.isEmpty {
                Map(position: $position) {
                    ForEach(garages, id: \.id) { garage in
                        if let loc = garage.garageLocation {
                            Annotation(garage.name, coordinate: loc.coordinate) {
                                VStack(spacing: 4) {
                                    Image(systemName: "mappin.circle.fill")
                                        .appFont(size: 24)
                                        .foregroundColor(.orange)
                                    Text(garage.name)
                                        .appFont(size: 10)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    // center map on average coordinate
                    let coords = garages.compactMap { $0.garageLocation?.coordinate }
                    if !coords.isEmpty {
                        let avgLat = coords.map { $0.latitude }.reduce(0, +) / Double(coords.count)
                        let avgLon = coords.map { $0.longitude }.reduce(0, +) / Double(coords.count)
                        position = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                    }
                }
            } else {
                Color.gray.opacity(0.2)
            }

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
                    Spacer()
                }
                .padding(16)
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    CompareMapView(garages: sampleGarages)
}
