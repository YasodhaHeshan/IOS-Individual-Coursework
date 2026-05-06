//
//  DamagePredictionService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine
import CoreML
import UIKit

class DamagePredictionService: ObservableObject {
    @Published var prediction: DamagePrediction?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    static let shared = DamagePredictionService()
    
    private init() {}
    
    // MARK: - Damage Category Prediction
    
    func predictDamageCategory(image: UIImage) async -> DamagePrediction? {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        guard let buffer = image.pixelBuffer(width: 224, height: 224) else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to process image"
                self.isLoading = false
            }
            return nil
        }
        
        // TODO: Load and use actual CoreML model
        // For now, we'll use a placeholder prediction
        let prediction = DamagePrediction(
            category: "General Damage",
            severity: .medium,
            confidence: 0.85,
            estimatedCostRange: (150.0, 500.0),
            recommendations: [
                "Professional inspection recommended",
                "Document with photos",
                "Get multiple quotes"
            ]
        )
        
        DispatchQueue.main.async {
            self.prediction = prediction
            self.isLoading = false
        }
        
        return prediction
    }
    
    // MARK: - Cost Estimation
    
    func estimateRepairCost(
        damageCategory: String,
        severity: DamageSeverity,
        vehicleMake: String,
        vehicleModel: String
    ) -> CostEstimate {
        // Base cost by category
        let baseCost: Double
        switch damageCategory.lowercased() {
        case "scratch":
            baseCost = 100.0
        case "dent":
            baseCost = 200.0
        case "broken glass":
            baseCost = 300.0
        case "mechanical":
            baseCost = 500.0
        case "engine":
            baseCost = 800.0
        default:
            baseCost = 250.0
        }
        
        // Multiply by severity
        let severityMultiplier: Double
        switch severity {
        case .low:
            severityMultiplier = 0.8
        case .medium:
            severityMultiplier = 1.0
        case .high:
            severityMultiplier = 1.5
        }
        
        let estimatedCost = baseCost * severityMultiplier
        let margin = estimatedCost * 0.2
        
        return CostEstimate(
            lowEstimate: estimatedCost - margin,
            highEstimate: estimatedCost + margin,
            midEstimate: estimatedCost,
            confidence: 0.75
        )
    }
    
    // MARK: - Spare Part Suggestion
    
    func suggestSpareParts(
        damageCategory: String,
        vehicleMake: String,
        vehicleModel: String
    ) -> [SparePart] {
        // This would typically query a database
        // For now, return placeholder data
        
        var parts: [SparePart] = []
        
        switch damageCategory.lowercased() {
        case "broken glass":
            parts = [
                SparePart(
                    name: "Windshield",
                    category: "Glass",
                    compatibility: vehicleModel,
                    price: 250.0
                ),
                SparePart(
                    name: "Side Window",
                    category: "Glass",
                    compatibility: vehicleModel,
                    price: 150.0
                )
            ]
        case "light":
            parts = [
                SparePart(
                    name: "Headlight Assembly",
                    category: "Lighting",
                    compatibility: vehicleModel,
                    price: 200.0
                )
            ]
        default:
            break
        }
        
        return parts
    }
}

// MARK: - Models

struct DamagePrediction {
    let category: String
    let severity: DamageSeverity
    let confidence: Double
    let estimatedCostRange: (min: Double, max: Double)
    let recommendations: [String]
}

struct CostEstimate {
    let lowEstimate: Double
    let highEstimate: Double
    let midEstimate: Double
    let confidence: Double
}

// MARK: - Extension

extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard let pixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
        
        let cgContext = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        
        guard let cgContext = cgContext else {
            return nil
        }
        
        cgContext.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelBuffer
    }
}
