//
//  CoreDataInterface.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData
import Foundation

protocol CoreDataInterfacing {
    var todaysWaterIntake: Result<WaterLogProgress, CoreDataInterfacingError> { get }
    func save(amount: Double) -> Result<Void, CoreDataInterfacingError>
}

protocol CoreDataInterfaceFactory {
    func makeCoreDataInterface() -> CoreDataInterfacing
}

final class CoreDataInterface: NSPersistentContainer {
    
    // Citation: https://nshipster.com/nspredicate/
    // Looked up proper syntax for writing predicates
    private let createdTodayPredicate: NSPredicate = {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = Date()
        let startDatePredicate = NSPredicate(format: "createdAt >= %@", startDate as NSDate)
        let endDatePredicate = NSPredicate(format: "createdAt < %@", endDate as NSDate)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startDatePredicate,
                                                                            endDatePredicate])
        return predicate
    }()
    
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
        loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // MARK: - Core Data Saving support

    func saveContext() -> Result<Void, CoreDataInterfacingError> {
        let managedContext = viewContext
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                return .success(())
            } catch {
                return .failure(CoreDataInterfacingError.saveContextFailure)
            }
        }
        
        return .success(())
    }
}

extension CoreDataInterface: CoreDataInterfacing {
    var todaysWaterIntake: Result<WaterLogProgress, CoreDataInterfacingError> {
        let managedContext = viewContext

        let recordFetch: NSFetchRequest<WaterLogRecord> = WaterLogRecord.fetchRequest()
        recordFetch.predicate = createdTodayPredicate
         
        do {
            let records = try managedContext.fetch(recordFetch)
            let sum = records.map { Int($0.amount) }.reduce(0, +)
            return .success(WaterLogProgress(amount: sum))
        } catch {
            return .failure(CoreDataInterfacingError.fetchFailure)
        }
    }

    func save(amount: Double) -> Result<Void, CoreDataInterfacingError> {
        let managedContext = viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WaterLogRecord",
                                                in: managedContext)!
        let record = WaterLogRecord(entity: entity,
                                    insertInto: managedContext)
        record.amount = Int16(amount)
        record.createdAt = Date()
        record.lastUpdated = Date()
        return saveContext()
    }
}
