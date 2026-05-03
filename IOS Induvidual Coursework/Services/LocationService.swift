//
//  LocationService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    @Published var isLocationAvailable = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    static let shared = LocationService()
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    // MARK: - Location Authorization
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            self.isLocationAvailable = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isLocationAvailable = false
            print("Location manager error: \(error.localizedDescription)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
    }
    
    // MARK: - Geocoding
    
    func geocodeAddress(_ address: String) async -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            return placemarks.first?.location?.coordinate
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func reverseGeocode(location: CLLocation) async -> String? {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            let placemark = placemarks.first
            
            var address = ""
            if let street = placemark?.thoroughfare {
                address += street + ", "
            }
            if let city = placemark?.locality {
                address += city + ", "
            }
            if let state = placemark?.administrativeArea {
                address += state + " "
            }
            if let zip = placemark?.postalCode {
                address += zip
            }
            
            return address.isEmpty ? nil : address
        } catch {
            print("Reverse geocoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
