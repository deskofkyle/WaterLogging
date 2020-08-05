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
    var todaysWaterIntake: Result<Int, Error> { get }
    func save(amount: Double) -> Result<Bool, Error>
}

protocol CoreDataInterfaceFactory {
    func makeCoreDataInterface() -> CoreDataInterfacing
}

final class CoreDataInterface: NSPersistentContainer {
    
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

    func saveContext() -> Result<Bool, Error> {
        let managedContext = viewContext
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                return .success(true)
            } catch {
                return .failure(CoreDataInterfacingError.fetchFailure)
            }
        }
        
        return .success(true)
    }
}

extension CoreDataInterface: CoreDataInterfacing {
    var todaysWaterIntake: Result<Int, Error> {
        let managedContext = viewContext

        let recordFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WaterLogRecord")
         
        do {
            guard let records = try managedContext.fetch(recordFetch) as? [NSManagedObject] else {
                return .failure(CoreDataInterfacingError.fetchFailure)
            }
            
            let result: [Double] = records.compactMap { record in
                guard let amount = record.value(forKey: "amount") as? Double,
                    let createdAt = record.value(forKey: "createdAt") as? Date,
                    let lastedUpdated = record.value(forKey: "lastUpdated") as? Date else { return nil }
                return amount
            }
            
            let sum = Int(result.reduce(0, +))
            return .success(sum)
        } catch {
            return .failure(CoreDataInterfacingError.fetchFailure)
        }
    }

    func save(amount: Double) -> Result<Bool, Error> {
        let managedContext = viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WaterLogRecord",
                                                in: managedContext)!
        let object = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        object.setValue(amount, forKeyPath: "amount")
        object.setValue(Date(), forKeyPath: "createdAt")
        object.setValue(Date(), forKeyPath: "lastUpdated")

        return saveContext()
    }
}
