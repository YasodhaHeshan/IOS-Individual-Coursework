//
//  TextRecognitionService.swift
//  IOS Induvidual Coursework
//
//  Created on 07/05/2026.
//

import Foundation
import Vision
import UIKit
import Combine

class TextRecognitionService: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecognizing = false
    @Published var errorMessage: String?
    
    static let shared = TextRecognitionService()
    
    private init() {}
    
    // MARK: - Text Recognition
    
    func recognizeText(from image: UIImage) async -> String {
        await MainActor.run {
            self.isRecognizing = true
            self.errorMessage = nil
            self.recognizedText = ""
        }
        
        guard let cgImage = image.cgImage else {
            await MainActor.run {
                self.errorMessage = "Invalid image"
                self.isRecognizing = false
            }
            return ""
        }
        
        let result = await extractText(from: cgImage)
        
        await MainActor.run {
            self.recognizedText = result
            self.isRecognizing = false
        }
        
        return result
    }
    
    private func extractText(from cgImage: CGImage) async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = VNRecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.recognitionLanguages = ["en-US"]
                
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    try handler.perform([request])
                    
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        continuation.resume(returning: "")
                        return
                    }
                    
                    let recognizedStrings = observations.compactMap { observation -> String? in
                        let candidate = observation.topCandidates(1).first
                        return candidate?.string
                    }
                    
                    let fullText = recognizedStrings.joined(separator: "\n")
                    continuation.resume(returning: fullText)
                } catch {
                    continuation.resume(returning: "")
                }
            }
        }
    }
}
