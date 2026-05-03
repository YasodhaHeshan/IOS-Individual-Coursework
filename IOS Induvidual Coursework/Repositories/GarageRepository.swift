//
//  GarageRepository.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import Foundation
import CoreData
import Combine

class GarageRepository: ObservableObject {
    @Published var garages: [Garage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabaseService = SupabaseService.shared
    private let coreDataStack = CoreDataStack.shared
    private let syncService = SyncService.shared
    
    static let shared = GarageRepository()
    
    private init() {}
    
    // MARK: - Fetch Operations
    
    func fetchGarages(forceRefresh: Bool = false) async {
        // Return cached if available and not forcing refresh
        if !garages.isEmpty && !forceRefresh {
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let fetchedGarages = try await supabaseService.fetchGarages()
            
            DispatchQueue.main.async {
                self.garages = fetchedGarages.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }
                self.isLoading = false
            }
            
            // Cache locally
            await cacheGarages(fetchedGarages)
        } catch {
            // Try to load from cache if network fails
            await loadCachedGarages()
            
            DispatchQueue.main.async {
                if self.garages.isEmpty {
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Caching
    
    private func cacheGarages(_ garages: [Garage]) async {
        let context = coreDataStack.viewContext
        
        // For now, simplified caching
        // In production, would create NSManagedObjects
        
        DispatchQueue.global(qos: .background).async {
            // Cache logic here
            self.coreDataStack.saveContext(context)
        }
    }
    
    private func loadCachedGarages() async {
        let context = coreDataStack.viewContext
        
        DispatchQueue.global(qos: .background).async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Garage")
            
            do {
                let results = try context.fetch(fetchRequest)
                // Map results back to Garage objects
                // self.garages = results
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load cached garages"
                }
            }
        }
    }
    
    // MARK: - Search & Filter
    
    func searchGarages(by keyword: String) async -> [Garage] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let filtered = self.garages.filter { garage in
                    garage.name.localizedCaseInsensitiveContains(keyword) ||
                    garage.category.localizedCaseInsensitiveContains(keyword) ||
                    (garage.description?.localizedCaseInsensitiveContains(keyword) ?? false)
                }
                continuation.resume(returning: filtered)
            }
        }
    }
    
    func filterGarages(maxPrice: String? = nil, minRating: Double? = nil) -> [Garage] {
        return garages.filter { garage in
            var matches = true
            
            if let minRating = minRating {
                matches = matches && (garage.rating ?? 0) >= minRating
            }
            
            return matches
        }
    }
    
    // MARK: - Favorite Management
    
    func saveFavorite(garage: Garage) async {
        syncService.addPendingChange()
        
        // Save to CoreData and Supabase
        let context = coreDataStack.viewContext
        
        // Simplified - would create NSManagedObject
        coreDataStack.saveContext(context)
        
        // Sync to cloud
        // await supabaseService.addFavorite(garageId: garage.id)
        
        syncService.removePendingChange()
    }
    
    func removeFavorite(garage: Garage) async {
        syncService.addPendingChange()
        
        let context = coreDataStack.viewContext
        // Remove from CoreData
        
        coreDataStack.saveContext(context)
        
        syncService.removePendingChange()
    }
}
