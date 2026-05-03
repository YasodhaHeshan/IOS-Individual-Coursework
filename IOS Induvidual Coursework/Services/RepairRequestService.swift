//
//  RepairRequestService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation

class RepairRequestService: ObservableObject {
    @Published var repairRequests: [RepairRequest] = []
    @Published var currentRequest: RepairRequest?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let authService = AuthService.shared
    
    static let shared = RepairRequestService()
    
    private init() {}
    
    // MARK: - Create Request
    
    func createRepairRequest(
        vehicleMake: String,
        vehicleModel: String,
        vehicleYear: Int,
        description: String,
        damageCategory: String,
        imageURLs: [String] = []
    ) async {
        guard let userId = authService.currentUser?.id else {
            DispatchQueue.main.async {
                self.errorMessage = "User not authenticated"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        let request = RepairRequest(
            id: UUID().uuidString,
            userId: userId,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            vehicleYear: vehicleYear,
            damageCategory: damageCategory,
            description: description,
            imageURLs: imageURLs,
            status: "pending",
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            let createdRequest = try await supabaseService.createRepairRequest(request)
            
            DispatchQueue.main.async {
                self.currentRequest = createdRequest
                self.repairRequests.append(createdRequest)
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Fetch Requests
    
    func fetchMyRepairRequests() async {
        guard let userId = authService.currentUser?.id else {
            DispatchQueue.main.async {
                self.errorMessage = "User not authenticated"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let requests = try await supabaseService.fetchRepairRequests(userId: userId)
            
            DispatchQueue.main.async {
                self.repairRequests = requests.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Update Request
    
    func updateRequestStatus(requestId: String, status: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            try await supabaseService.updateRepairRequestStatus(id: requestId, status: status)
            
            DispatchQueue.main.async {
                if let index = self.repairRequests.firstIndex(where: { $0.id == requestId }) {
                    self.repairRequests[index].status = status
                    self.repairRequests[index].updatedAt = Date()
                }
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Delete Request
    
    func deleteRepairRequest(id: String) async {
        do {
            // Make API call to delete
            // await supabaseService.deleteRepairRequest(id: id)
            
            DispatchQueue.main.async {
                self.repairRequests.removeAll { $0.id == id }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
