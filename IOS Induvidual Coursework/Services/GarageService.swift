//
//  GarageService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import MapKit
import Combine

class GarageService: ObservableObject {
    @Published var garages: [Garage] = []
    @Published var nearbyGarages: [Garage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let locationService = LocationService.shared
    
    static let shared = GarageService()
    
    private init() {}
    
    // MARK: - Fetch Garages
    
    func fetchAllGarages() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let fetchedGarages = try await supabaseService.fetchGarages()
            DispatchQueue.main.async {
                self.garages = fetchedGarages
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func fetchGarageDetails(id: String) async throws -> Garage {
        return try await supabaseService.fetchGarageDetail(id: id)
    }
    
    // MARK: - Location-based search
    
    func findNearbyGarages(radius: CLLocationDistance = 5000) async {
        guard let userLocation = locationService.currentLocation else {
            DispatchQueue.main.async {
                self.errorMessage = "Location not available"
            }
            return
        }
        
        await fetchAllGarages()
        
        DispatchQueue.main.async {
            self.nearbyGarages = self.garages.filter { garage in
                guard let garageLocation = garage.garageLocation else { return false }
                let distance = userLocation.distance(from: garageLocation)
                return distance <= radius
            }.sorted { garage1, garage2 in
                guard let loc1 = garage1.garageLocation,
                      let loc2 = garage2.garageLocation else { return false }
                let distance1 = userLocation.distance(from: loc1)
                let distance2 = userLocation.distance(from: loc2)
                return distance1 < distance2
            }
        }
    }
    
    // MARK: - Garage Ranking
    
    func rankGarages(by: RankingCriteria = .distance) {
        switch by {
        case .distance:
            nearbyGarages.sort { (garage1: Garage, garage2: Garage) in
                guard let loc1 = garage1.garageLocation,
                      let loc2 = garage2.garageLocation,
                      let userLoc = locationService.currentLocation else { return false }
                let dist1 = userLoc.distance(from: loc1)
                let dist2 = userLoc.distance(from: loc2)
                return dist1 < dist2
            }
        case .rating:
            nearbyGarages.sort { (garage1: Garage, garage2: Garage) in
                (garage1.rating ?? 0) > (garage2.rating ?? 0)
            }
        case .price:
            nearbyGarages.sort { (garage1: Garage, garage2: Garage) in
                garage1.priceRange.count < garage2.priceRange.count
            }
        }
    }
    
    enum RankingCriteria {
        case distance
        case rating
        case price
    }
    
    // MARK: - Distance and Time
    
    func getDistance(to garage: Garage) -> CLLocationDistance? {
        guard let garageLocation = garage.garageLocation,
              let userLocation = locationService.currentLocation else {
            return nil
        }
        return userLocation.distance(from: garageLocation)
    }
    
    func getDirections(to garage: Garage) async -> MKDirections.Response? {
        guard let garageLocation = garage.garageLocation,
              let userLocation = locationService.currentLocation else {
            return nil
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: garageLocation.coordinate))
        
        let directions = MKDirections(request: request)
        
        return try? await directions.calculate()
    }
}
