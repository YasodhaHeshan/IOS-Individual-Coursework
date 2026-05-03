//
//  ImageUploadService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import UIKit

class ImageUploadService: ObservableObject {
    @Published var uploadProgress: Double = 0
    @Published var isUploading = false
    @Published var errorMessage: String?
    
    static let shared = ImageUploadService()
    
    private let supabaseURL = SupabaseService.shared
    
    private init() {}
    
    // MARK: - Upload Image
    
    func uploadImage(_ image: UIImage, to bucket: String, filename: String) async throws -> String {
        DispatchQueue.main.async {
            self.isUploading = true
            self.errorMessage = nil
            self.uploadProgress = 0
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw UploadError.invalidImage
        }
        
        let endpoint = "YOUR_SUPABASE_URL/storage/v1/object/\(bucket)/\(filename)"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("YOUR_SUPABASE_KEY", forHTTPHeaderField: "apikey")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw UploadError.uploadFailed
        }
        
        let decoder = JSONDecoder()
        let uploadResponse = try decoder.decode(UploadResponse.self, from: data)
        
        DispatchQueue.main.async {
            self.isUploading = false
            self.uploadProgress = 1.0
        }
        
        return uploadResponse.path
    }
    
    func uploadMultipleImages(_ images: [UIImage], to bucket: String) async -> [String] {
        var uploadedPaths: [String] = []
        
        for (index, image) in images.enumerated() {
            let filename = "repair_\(UUID().uuidString)_\(index).jpg"
            
            do {
                let path = try await uploadImage(image, to: bucket, filename: filename)
                uploadedPaths.append(path)
                
                DispatchQueue.main.async {
                    self.uploadProgress = Double(index + 1) / Double(images.count)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to upload image \(index + 1)"
                }
            }
        }
        
        DispatchQueue.main.async {
            self.isUploading = false
        }
        
        return uploadedPaths
    }
    
    enum UploadError: Error {
        case invalidImage
        case uploadFailed
        case networkError
    }
}

struct UploadResponse: Codable {
    let path: String
    let id: String?
}
