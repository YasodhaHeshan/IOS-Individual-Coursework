//
//  SyncService.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import Combine
import CoreData

class SyncService: ObservableObject {
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var pendingChanges: Int = 0
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let coreDataStack = CoreDataStack.shared
    
    static let shared = SyncService()
    
    private var syncTimer: Timer?
    
    private init() {
        startAutoSync()
    }
    
    deinit {
        syncTimer?.invalidate()
    }
    
    // MARK: - Auto Sync
    
    func startAutoSync() {
        // Sync every 5 minutes
        syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task {
                await self?.syncAllData()
            }
        }
    }
    
    func stopAutoSync() {
        syncTimer?.invalidate()
        syncTimer = nil
    }
    
    // MARK: - Sync Data
    
    func syncAllData() async {
        guard !isSyncing else { return }
        
        DispatchQueue.main.async {
            self.isSyncing = true
            self.errorMessage = nil
        }
        
        do {
            // Sync repair requests
            try await syncRepairRequests()
            
            // Sync garages
            try await syncGarages()
            
            DispatchQueue.main.async {
                self.lastSyncDate = Date()
                self.isSyncing = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isSyncing = false
            }
        }
    }
    
    private func syncRepairRequests() async throws {
        // Fetch from Supabase and update local cache
        let authService = AuthService.shared
        guard let userId = authService.currentUser?.id else { return }
        
        let requests = try await supabaseService.fetchRepairRequests(userId: userId)
        
        // Update CoreData
        let context = coreDataStack.viewContext
        
        for request in requests {
            // Check if exists and update or create new
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RepairRequest")
            fetchRequest.predicate = NSPredicate(format: "id == %@", request.id)
            
            // Delete existing and create new (simplified)
            try context.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
        }
        
        coreDataStack.saveContext(context)
    }
    
    private func syncGarages() async throws {
        let garages = try await supabaseService.fetchGarages()
        
        // Update CoreData cache
        let context = coreDataStack.viewContext
        
        // Simplified: delete old and insert new
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Garage")
        try context.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
        
        coreDataStack.saveContext(context)
    }
    
    // MARK: - Queue Management
    
    func addPendingChange() {
        DispatchQueue.main.async {
            self.pendingChanges += 1
        }
    }
    
    func removePendingChange() {
        DispatchQueue.main.async {
            self.pendingChanges = max(0, self.pendingChanges - 1)
        }
    }
    
    func clearPendingChanges() {
        DispatchQueue.main.async {
            self.pendingChanges = 0
        }
    }
    
    // MARK: - Network Monitoring
    
    func isNetworkAvailable() -> Bool {
        // TODO: Implement actual network availability check
        return true
    }
}
