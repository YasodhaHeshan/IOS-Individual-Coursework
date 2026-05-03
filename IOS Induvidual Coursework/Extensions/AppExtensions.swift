//
//  AppExtensions.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import CoreLocation

// MARK: - CLLocation Extension

extension CLLocation {
    func distance(to location: CLLocation) -> CLLocationDistance {
        return self.distance(from: location)
    }
}

// MARK: - Date Extension

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var dateOnly: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    var timeOnly: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - String Extension

extension String {
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        return self.count >= 8
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[+]?[(]?[0-9]{1,4}[)]?[-\\s.]?[(]?[0-9]{1,4}[)]?[-\\s.]?[0-9]{1,9}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
    }
}

// MARK: - Double Extension

extension Double {
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "LKR"
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    var distanceFormatted: String {
        if self < 1000 {
            return String(format: "%.0f m", self)
        } else {
            return String(format: "%.1f km", self / 1000)
        }
    }
}

// MARK: - Array Extension

extension Array where Element: Identifiable {
    func contains(_ element: Element) -> Bool {
        return self.contains { $0.id == element.id }
    }
    
    mutating func togglePresence(of element: Element) {
        if let index = self.firstIndex(where: { $0.id == element.id }) {
            self.remove(at: index)
        } else {
            self.append(element)
        }
    }
}

// MARK: - Comparable Extension

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

// MARK: - Dictionary Extension

extension Dictionary {
    mutating func merge(_ other: [Key: Value]) {
        for (key, value) in other {
            self[key] = value
        }
    }
}
