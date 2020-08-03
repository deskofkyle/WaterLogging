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
    var todaysWaterIntake: Result<Double, Error> { get }
    func save(record: WaterLogRecord) -> Result<Bool, Error>
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

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // no-op
            }
        }
    }
}

extension CoreDataInterface: CoreDataInterfacing {
    var todaysWaterIntake: Result<Double, Error> {
        return .success(300)
    }

    func save(record: WaterLogRecord) -> Result<Bool, Error> {
        let managedContext = viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WaterLoggingRecord",
                                                in: managedContext)!
        let object = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        object.setValue(record.amount, forKeyPath: "amount")
        object.setValue(record.createdAt, forKeyPath: "createdAt")
        object.setValue(record.lastUpdated, forKeyPath: "lastUpdated")

        do {
            try managedContext.save()
            return .success(true)
        } catch let error as NSError {
            return .failure(error)
        }
    }
}
