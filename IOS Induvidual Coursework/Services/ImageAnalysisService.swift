//
//  ImageAnalysisService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Vision
import UIKit
import CoreML
import Combine

class ImageAnalysisService: ObservableObject {
    @Published var analyzedImage: AnalyzedImage?
    @Published var isAnalyzing = false
    @Published var errorMessage: String?
    
    static let shared = ImageAnalysisService()
    
    private init() {}
    
    // MARK: - Image Quality Check
    
    func checkImageQuality(_ image: UIImage) -> ImageQuality {
        guard let cgImage = image.cgImage else {
            return .poor(reason: "Invalid image")
        }
        
        // Try to detect rectangles (damage regions) for quality check
        let request = VNDetectRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
            if let observations = request.results as? [VNRectangleObservation], !observations.isEmpty {
                return .good
            }
            return .average
        } catch {
            return .poor(reason: "Invalid image format")
        }
    }
    
    enum ImageQuality {
        case good
        case average
        case poor(reason: String)
    }
    
    // MARK: - Damage Detection
    
    func analyzeDamageImage(_ image: UIImage) async -> DamageAnalysis? {
        DispatchQueue.main.async {
            self.isAnalyzing = true
            self.errorMessage = nil
        }
        
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid image"
                self.isAnalyzing = false
            }
            return nil
        }
        
        // Resize image for ML model
        let resizedImage = image.resized(to: CGSize(width: 224, height: 224))
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Detect damage regions
                    let damageRegions = try self.detectDamageRegions(cgImage)
                    
                    // Analyze severity
                    let severity = self.analyzeSeverity(image: cgImage, regions: damageRegions)
                    
                    // Extract features
                    let features = try self.extractImageFeatures(cgImage)
                    
                    let analysis = DamageAnalysis(
                        severity: severity,
                        damageRegions: damageRegions,
                        features: features,
                        quality: self.checkImageQuality(image)
                    )
                    
                    DispatchQueue.main.async {
                        self.analyzedImage = AnalyzedImage(
                            image: image,
                            analysis: analysis
                        )
                        self.isAnalyzing = false
                    }
                    
                    continuation.resume(returning: analysis)
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isAnalyzing = false
                    }
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func detectDamageRegions(_ cgImage: CGImage) throws -> [DamageRegion] {
        let request = VNDetectRectanglesRequest()
        request.maximumObservations = 3
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        
        guard let observations = request.results as? [VNRectangleObservation] else {
            return []
        }
        
        return observations.map { observation in
            DamageRegion(
                boundingBox: observation.boundingBox,
                confidence: CGFloat(observation.confidence)
            )
        }
    }
    
    private func analyzeSeverity(image: CGImage, regions: [DamageRegion]) -> DamageSeverity {
        let regionCount = regions.count
        let averageConfidence = regions.isEmpty ? 0 : regions.map { CGFloat($0.confidence) }.reduce(0, +) / CGFloat(regions.count)
        
        if averageConfidence > 0.7 && regionCount > 2 {
            return .high
        } else if averageConfidence > 0.5 && regionCount > 1 {
            return .medium
        } else {
            return .low
        }
    }
    
    private func extractImageFeatures(_ cgImage: CGImage) throws -> [String: Any] {
        var features: [String: Any] = [:]
        
        // Extract text using Vision's text recognition
        let textRequest = VNRecognizeTextRequest()
        textRequest.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([textRequest])
        
        if let textObservations = textRequest.results as? [VNRecognizedTextObservation] {
            let recognizedText = textObservations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ")
            features["recognizedText"] = recognizedText
        }
        
        return features
    }
}

// MARK: - Models

struct DamageAnalysis {
    let severity: DamageSeverity
    let damageRegions: [DamageRegion]
    let features: [String: Any]
    let quality: ImageAnalysisService.ImageQuality
}

struct DamageRegion {
    let boundingBox: CGRect
    let confidence: CGFloat
}

enum DamageSeverity: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct AnalyzedImage {
    let image: UIImage
    let analysis: DamageAnalysis
}

// MARK: - Extension

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
