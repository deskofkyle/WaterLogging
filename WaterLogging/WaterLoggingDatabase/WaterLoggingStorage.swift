//
//  WaterLoggingDatabase.swift
//  WaterLoggingDatabase
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import WaterLoggingModels

public protocol WaterLoggingStoring {
    func save(record: WLRecord)
}

protocol WaterLoggingStorageFactory {
    func makeWaterLoggingStorage() -> WaterLoggingStoring
}

final class WaterLoggingStorage: WaterLoggingStoring {
    
    private let coreDataInterface: CoreDataInterfacing

    init(coreDataInterface: CoreDataInterfacing) {
        self.coreDataInterface = coreDataInterface
    }
    
    func save(record: WLRecord) {
        coreDataInterface.save(record: record)
    }
}
