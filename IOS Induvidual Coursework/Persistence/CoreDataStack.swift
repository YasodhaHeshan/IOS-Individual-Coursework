//
//  CoreDataStack.swift
//  IOS Induvidual Coursework
//
//  Created on 03/05/2026.
//

import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IOS_Induvidual_Coursework")
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext(_ context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - AppNotification CoreData helpers

    func saveNotification(_ notification: AppNotification, userId: String?) {
        let context = viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppNotification")
        fetchRequest.predicate = NSPredicate(format: "id == %@", notification.id)

        let existing = (try? context.fetch(fetchRequest))?.first
        let obj = existing ?? NSEntityDescription.insertNewObject(forEntityName: "AppNotification", into: context)

        obj.setValue(notification.id, forKey: "id")
        obj.setValue(notification.title, forKey: "title")
        obj.setValue(notification.body, forKey: "body")
        obj.setValue(notification.type.rawValue, forKey: "type")
        obj.setValue(notification.read, forKey: "read")
        obj.setValue(notification.createdAt, forKey: "createdAt")
        obj.setValue(notification.associatedRequestId, forKey: "associatedRequestId")
        obj.setValue(userId, forKey: "userId")

        saveContext(context)
    }

    func fetchNotifications(userId: String) -> [AppNotification] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppNotification")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        guard let results = try? viewContext.fetch(fetchRequest) else { return [] }

        return results.compactMap { obj in
            guard
                let id = obj.value(forKey: "id") as? String,
                let title = obj.value(forKey: "title") as? String,
                let body = obj.value(forKey: "body") as? String,
                let typeRaw = obj.value(forKey: "type") as? String
            else { return nil }

            let type = AppNotification.NotificationType(rawValue: typeRaw) ?? .generalUpdate
            let read = (obj.value(forKey: "read") as? NSNumber)?.boolValue ?? false
            let createdAt = (obj.value(forKey: "createdAt") as? Date) ?? Date()
            let associatedRequestId = obj.value(forKey: "associatedRequestId") as? String

            return AppNotification(
                id: id,
                title: title,
                body: body,
                type: type,
                read: read,
                createdAt: createdAt,
                associatedRequestId: associatedRequestId
            )
        }
    }

    func markNotificationRead(id: String) {
        let context = viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AppNotification")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        if let obj = (try? context.fetch(fetchRequest))?.first {
            obj.setValue(true, forKey: "read")
            saveContext(context)
        }
    }

    // MARK: - RepairRequest CoreData helpers

    func saveRepairRequest(_ request: RepairRequest) {
        let context = viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepairRequest")
        fetchRequest.predicate = NSPredicate(format: "id == %@", request.id)

        let existing = (try? context.fetch(fetchRequest))?.first
        let obj = existing ?? NSEntityDescription.insertNewObject(forEntityName: "RepairRequest", into: context)

        obj.setValue(request.id, forKey: "id")
        obj.setValue(request.userId, forKey: "userId")
        obj.setValue(request.vehicleMake, forKey: "vehicleMake")
        obj.setValue(request.vehicleModel, forKey: "vehicleModel")
        obj.setValue(Int16(request.vehicleYear), forKey: "vehicleYear")
        obj.setValue(request.damageCategory, forKey: "damageCategory")
        obj.setValue(request.description, forKey: "descriptionText")
        obj.setValue(request.imageURLs as NSArray, forKey: "imageURLs")
        obj.setValue(request.predictedCost ?? 0, forKey: "predictedCost")
        obj.setValue(request.predictedConfidence ?? 0, forKey: "predictedConfidence")
        obj.setValue(request.selectedGarageId, forKey: "selectedGarageId")
        obj.setValue(request.status, forKey: "status")
        obj.setValue(request.createdAt ?? Date(), forKey: "createdAt")
        obj.setValue(request.updatedAt ?? Date(), forKey: "updatedAt")

        saveContext(context)
    }

    func fetchRepairRequests(userId: String) -> [RepairRequest] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RepairRequest")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        guard let results = try? viewContext.fetch(fetchRequest) else { return [] }

        return results.compactMap { obj in
            guard
                let id = obj.value(forKey: "id") as? String,
                let userId = obj.value(forKey: "userId") as? String,
                let vehicleMake = obj.value(forKey: "vehicleMake") as? String,
                let vehicleModel = obj.value(forKey: "vehicleModel") as? String,
                let damageCategory = obj.value(forKey: "damageCategory") as? String,
                let description = obj.value(forKey: "descriptionText") as? String,
                let status = obj.value(forKey: "status") as? String
            else { return nil }

            let vehicleYear = (obj.value(forKey: "vehicleYear") as? NSNumber)?.intValue ?? 0
            let imageURLs = obj.value(forKey: "imageURLs") as? [String] ?? []
            let predictedCost = (obj.value(forKey: "predictedCost") as? NSNumber)?.doubleValue
            let predictedConfidence = (obj.value(forKey: "predictedConfidence") as? NSNumber)?.doubleValue
            let selectedGarageId = obj.value(forKey: "selectedGarageId") as? String
            let createdAt = obj.value(forKey: "createdAt") as? Date
            let updatedAt = obj.value(forKey: "updatedAt") as? Date

            return RepairRequest(
                id: id,
                userId: userId,
                vehicleMake: vehicleMake,
                vehicleModel: vehicleModel,
                vehicleYear: vehicleYear,
                damageCategory: damageCategory,
                description: description,
                imageURLs: imageURLs,
                predictedCost: predictedCost,
                predictedConfidence: predictedConfidence,
                selectedGarageId: selectedGarageId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }

    func deleteAllData() {
        let entities = persistentContainer.managedObjectModel.entities
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try viewContext.execute(deleteRequest)
                try viewContext.save()
            } catch {
                print("Error deleting data: \(error)")
            }
        }
    }
}
