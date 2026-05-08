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
        let authService = AuthService.shared
        guard let userId = authService.currentUser?.id else { return }

        let requests = try await supabaseService.fetchRepairRequests(userId: userId)
        for request in requests {
            coreDataStack.saveRepairRequest(request)
        }
    }

    private func syncGarages() async throws {
        let garages = try await supabaseService.fetchGarages()
        let context = coreDataStack.viewContext

        for garage in garages {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Garage")
            fetchRequest.predicate = NSPredicate(format: "id == %@", garage.id as CVarArg)

            let existing = (try? context.fetch(fetchRequest))?.first
            let obj = existing ?? NSEntityDescription.insertNewObject(forEntityName: "Garage", into: context)

            obj.setValue(garage.id, forKey: "id")
            obj.setValue(garage.name, forKey: "name")
            obj.setValue(garage.location, forKey: "location")
            obj.setValue(garage.address ?? "", forKey: "address")
            obj.setValue(garage.phone ?? "", forKey: "phone")
            obj.setValue(garage.rating ?? 0, forKey: "rating")
            obj.setValue(garage.isVerified, forKey: "isVerified")
            obj.setValue(garage.category, forKey: "category")
            obj.setValue(garage.priceRange, forKey: "priceRange")
            obj.setValue(garage.imageName, forKey: "imageName")
            obj.setValue(garage.imageURL, forKey: "imageURL")
            obj.setValue(garage.openHours, forKey: "openHours")
            obj.setValue(garage.latitude ?? 0, forKey: "latitude")
            obj.setValue(garage.longitude ?? 0, forKey: "longitude")
            obj.setValue(garage.specializations as? NSArray, forKey: "specializations")
        }

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
