//
//  RepairRequestService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine

class RepairRequestService: ObservableObject {
    @Published var repairRequests: [RepairRequest] = []
    @Published var currentRequest: RepairRequest?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabaseService = SupabaseService.shared
    private let authService = AuthService.shared
    private let coreDataStack = CoreDataStack.shared

    static let shared = RepairRequestService()

    private init() {}

    // MARK: - Create Request

    func createRepairRequest(
        vehicleMake: String,
        vehicleModel: String,
        vehicleYear: Int,
        description: String,
        damageCategory: String,
        imageURLs: [String] = [],
        predictedCost: Double? = nil,
        predictedConfidence: Double? = nil
    ) async {
        guard let userId = authService.currentUser?.id else {
            DispatchQueue.main.async { self.errorMessage = "User not authenticated" }
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        var request = RepairRequest(
            id: UUID().uuidString,
            userId: userId,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            vehicleYear: vehicleYear,
            damageCategory: damageCategory,
            description: description,
            imageURLs: imageURLs,
            predictedCost: predictedCost,
            predictedConfidence: predictedConfidence,
            status: "pending",
            createdAt: Date(),
            updatedAt: Date()
        )

        // 1. Save to CoreData immediately (works offline too)
        coreDataStack.saveRepairRequest(request)

        // 2. Persist to Supabase; on failure keep the local copy
        do {
            let serverRequest = try await supabaseService.createRepairRequest(request)
            // Update CoreData with any server-assigned values
            request = serverRequest
            coreDataStack.saveRepairRequest(serverRequest)

            DispatchQueue.main.async {
                self.currentRequest = serverRequest
                if !self.repairRequests.contains(where: { $0.id == serverRequest.id }) {
                    self.repairRequests.insert(serverRequest, at: 0)
                }
                self.isLoading = false
            }
        } catch {
            // Supabase failed — the record is already in CoreData; surface a non-blocking warning
            DispatchQueue.main.async {
                self.currentRequest = request
                if !self.repairRequests.contains(where: { $0.id == request.id }) {
                    self.repairRequests.insert(request, at: 0)
                }
                self.isLoading = false
                print("⚠️ Supabase save failed (saved locally): \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fetch Requests

    func fetchMyRepairRequests() async {
        guard let userId = authService.currentUser?.id else {
            DispatchQueue.main.async { self.errorMessage = "User not authenticated" }
            return
        }

        DispatchQueue.main.async { self.isLoading = true; self.errorMessage = nil }

        // Load from CoreData first for instant display
        let localRequests = coreDataStack.fetchRepairRequests(userId: userId)
        if !localRequests.isEmpty {
            DispatchQueue.main.async { self.repairRequests = localRequests }
        }

        // Then sync from Supabase
        do {
            let remoteRequests = try await supabaseService.fetchRepairRequests(userId: userId)
            // Upsert each into CoreData
            for r in remoteRequests { coreDataStack.saveRepairRequest(r) }
            let sorted = remoteRequests.sorted { $0.createdAt ?? Date() > $1.createdAt ?? Date() }
            DispatchQueue.main.async {
                self.repairRequests = sorted
                self.isLoading = false
            }
        } catch {
            // Supabase unreachable — show cached data
            let cached = coreDataStack.fetchRepairRequests(userId: userId)
            DispatchQueue.main.async {
                self.repairRequests = cached
                self.isLoading = false
                print("⚠️ Supabase fetch failed, showing cached data: \(error.localizedDescription)")
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
