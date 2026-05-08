//
//  DamagePredictionService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine
import CoreML
import Vision
import UIKit

class DamagePredictionService: ObservableObject {
    @Published var prediction: DamagePrediction?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    static let shared = DamagePredictionService()

    private lazy var visionModel: VNCoreMLModel? = {
        do {
            if let compiledURL = Bundle.main.url(forResource: "car-damage", withExtension: "mlmodelc") {
                let model = try MLModel(contentsOf: compiledURL)
                return try VNCoreMLModel(for: model)
            }

            if let packageURL = Bundle.main.url(forResource: "car-damage", withExtension: "mlpackage") {
                let compiledURL = try MLModel.compileModel(at: packageURL)
                let model = try MLModel(contentsOf: compiledURL)
                return try VNCoreMLModel(for: model)
            }
        } catch {
            self.errorMessage = "Failed to load damage model: \(error.localizedDescription)"
        }

        return nil
    }()
    
    private init() {}
    
    // MARK: - Damage Category Prediction
    
    func predictDamageCategory(image: UIImage) async -> DamagePrediction? {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to process image"
                self.isLoading = false
            }
            return nil
        }

        guard let visionModel else {
            DispatchQueue.main.async {
                self.errorMessage = "Damage model is not available in app bundle"
                self.isLoading = false
            }
            return nil
        }

        let classification: VNClassificationObservation? = await withCheckedContinuation { continuation in
            let request = VNCoreMLRequest(model: visionModel) { request, _ in
                let result = (request.results as? [VNClassificationObservation])?.first
                continuation.resume(returning: result)
            }

            request.imageCropAndScaleOption = .centerCrop

            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }

        guard let classification else {
            DispatchQueue.main.async {
                self.errorMessage = "Unable to predict damage severity"
                self.isLoading = false
            }
            return nil
        }

        let severity = mapSeverity(from: classification.identifier)
        let prediction = DamagePrediction(
            category: prettyCategoryName(from: classification.identifier),
            severity: severity,
            confidence: Double(classification.confidence),
            estimatedCostRange: estimatedRange(for: severity),
            recommendations: recommendations(for: severity)
        )

        DispatchQueue.main.async {
            self.prediction = prediction
            self.isLoading = false
        }

        return prediction
    }

    private func mapSeverity(from identifier: String) -> DamageSeverity {
        let normalized = identifier.lowercased()

        if normalized.contains("severe") {
            return .high
        }

        if normalized.contains("moderate") {
            return .medium
        }

        if normalized.contains("minor") || normalized.contains("light") {
            return .low
        }

        return .medium
    }

    private func prettyCategoryName(from identifier: String) -> String {
        let cleaned = identifier
            .replacingOccurrences(of: "01-", with: "")
            .replacingOccurrences(of: "02-", with: "")
            .replacingOccurrences(of: "03-", with: "")
            .capitalized

        if cleaned == "Minor" {
            return "Light Damage"
        }

        if cleaned == "Moderate" {
            return "Moderate Damage"
        }

        if cleaned == "Severe" {
            return "Severe Damage"
        }

        return cleaned
    }

    private func estimatedRange(for severity: DamageSeverity) -> (min: Double, max: Double) {
        switch severity {
        case .low:
            return (8_000.0, 25_000.0)
        case .medium:
            return (25_000.0, 60_000.0)
        case .high:
            return (60_000.0, 150_000.0)
        }
    }

    private func recommendations(for severity: DamageSeverity) -> [String] {
        switch severity {
        case .low:
            return [
                "Minor damage detected; schedule a routine garage check",
                "Keep photos for insurance records",
                "Compare at least two quotes"
            ]
        case .medium:
            return [
                "Moderate damage detected; inspect within 24-48 hours",
                "Avoid long trips until inspected",
                "Request itemized parts and labor estimate"
            ]
        case .high:
            return [
                "Severe damage detected; arrange urgent professional inspection",
                "Avoid driving if safety systems may be affected",
                "Contact insurance support immediately"
            ]
        }
    }
    
    // MARK: - Cost Estimation
    
    func estimateRepairCost(
        damageCategory: String,
        severity: DamageSeverity,
        vehicleMake: String,
        vehicleModel: String
    ) -> CostEstimate {
        // Base cost in LKR by category
        let baseCost: Double
        switch damageCategory.lowercased() {
        case "scratch":
            baseCost = 8_000.0
        case "dent":
            baseCost = 18_000.0
        case "broken glass":
            baseCost = 28_000.0
        case "mechanical":
            baseCost = 45_000.0
        case "engine":
            baseCost = 80_000.0
        case "light damage":
            baseCost = 10_000.0
        case "moderate damage":
            baseCost = 35_000.0
        case "severe damage":
            baseCost = 90_000.0
        default:
            baseCost = 22_000.0
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
