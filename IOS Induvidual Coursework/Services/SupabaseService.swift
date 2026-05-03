//
//  SupabaseService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation

class SupabaseService {
    static let shared = SupabaseService()
    
    // TODO: Replace with actual Supabase credentials
    private let supabaseURL = URL(string: "https://pcckjmtfpqbcymvrumqg.supabase.co")!
    private let supabaseKey = "sb_publishable_BCeUrPIBRA7Mpq2rzadiwQ_BaYi6a_7"
    
    private var authToken: String?
    
    private init() {}
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> User {
        let endpoint = "\(supabaseURL)/auth/v1/signup"
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let data = try JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        request.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(AuthResponse.self, from: responseData)
        
        self.authToken = response.session.accessToken
        
        return response.user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let endpoint = "\(supabaseURL)/auth/v1/token?grant_type=password"
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let data = try JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        request.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(AuthResponse.self, from: responseData)
        
        self.authToken = response.session.accessToken
        
        return response.user
    }
    
    func signOut() async throws {
        guard let token = authToken else { return }
        
        let endpoint = "\(supabaseURL)/auth/v1/logout"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        
        _ = try await URLSession.shared.data(for: request)
        
        self.authToken = nil
    }
    
    func resetPassword(email: String) async throws {
        let endpoint = "\(supabaseURL)/auth/v1/recovery"
        
        let body: [String: Any] = ["email": email]
        let data = try JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        request.httpBody = data
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - User Profile
    
    func createUserProfile(userId: String, email: String, fullName: String) async throws {
        let endpoint = "\(supabaseURL)/rest/v1/profiles"
        
        let body: [String: Any] = [
            "id": userId,
            "email": email,
            "full_name": fullName,
            "created_at": ISO8601DateFormatter().string(from: Date()),
            "updated_at": ISO8601DateFormatter().string(from: Date())
        ]
        
        let data = try JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = data
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func getUserProfile(userId: String) async throws -> User {
        let endpoint = "\(supabaseURL)/rest/v1/profiles?id=eq.\(userId)"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let users = try decoder.decode([User].self, from: responseData)
        
        guard let user = users.first else {
            throw NSError(domain: "SupabaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        return user
    }
    
    // MARK: - Garages
    
    func fetchGarages() async throws -> [Garage] {
        let endpoint = "\(supabaseURL)/rest/v1/garages"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let garages = try decoder.decode([Garage].self, from: responseData)
        
        return garages
    }
    
    func fetchGarageDetail(id: String) async throws -> Garage {
        let endpoint = "\(supabaseURL)/rest/v1/garages?id=eq.\(id)"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let garages = try decoder.decode([Garage].self, from: responseData)
        
        guard let garage = garages.first else {
            throw NSError(domain: "SupabaseService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Garage not found"])
        }
        
        return garage
    }
    
    // MARK: - Repair Requests
    
    func createRepairRequest(_ request: RepairRequest) async throws -> RepairRequest {
        let endpoint = "\(supabaseURL)/rest/v1/repair_requests"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(request)
        
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        if let token = authToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let createdRequest = try decoder.decode(RepairRequest.self, from: responseData)
        
        return createdRequest
    }
    
    func fetchRepairRequests(userId: String) async throws -> [RepairRequest] {
        let endpoint = "\(supabaseURL)/rest/v1/repair_requests?user_id=eq.\(userId)"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let requests = try decoder.decode([RepairRequest].self, from: responseData)
        
        return requests
    }
    
    func updateRepairRequestStatus(id: String, status: String) async throws {
        let endpoint = "\(supabaseURL)/rest/v1/repair_requests?id=eq.\(id)"
        
        let body: [String: Any] = [
            "status": status,
            "updated_at": ISO8601DateFormatter().string(from: Date())
        ]
        
        let data = try JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = data
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Spare Parts
    
    func fetchSpareParts() async throws -> [SparePart] {
        let endpoint = "\(supabaseURL)/rest/v1/spare_parts"
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let parts = try decoder.decode([SparePart].self, from: responseData)
        
        return parts
    }
}

// MARK: - Helper Models

struct AuthResponse: Codable {
    let user: User
    let session: Session
}

struct Session: Codable {
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
