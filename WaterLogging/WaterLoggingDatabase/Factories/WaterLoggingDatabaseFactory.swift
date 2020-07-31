//
//  WaterLoggingDatabasFactory.swift
//  WaterLoggingDatabase
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

public final class WaterLoggingDatabaseFactory {
    public static let shared = WaterLoggingDatabaseFactory()
}

extension WaterLoggingDatabaseFactory: WaterLoggingStorageFactory {
    public func makeWaterLoggingStorage() -> WaterLoggingStoring {
        let coreDataInterface = makeCoreDataInterface()
        return WaterLoggingStorage(coreDataInterface: coreDataInterface)
    }
}

extension WaterLoggingDatabaseFactory: CoreDataInterfaceFactory {
    func makeCoreDataInterface() -> CoreDataInterfacing {
        return CoreDataInterface(name: "WaterLoggingDataModel")
    }
}
