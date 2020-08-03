//
//  WaterLoggingDatabase.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterLoggingStoring {
    var todaysWaterIntake: Result<Double, Error> { get }
    func save(record: WaterLogRecord) -> Result<Bool, Error>
}

protocol WaterLoggingStorageFactory {
    func makeWaterLoggingStorage() -> WaterLoggingStoring
}

final class WaterLoggingStorage: WaterLoggingStoring {
    
    private let coreDataInterface: CoreDataInterfacing
    
    /// Returns the sum of that water in-take for today's date
    var todaysWaterIntake: Result<Double, Error> {
        return coreDataInterface.todaysWaterIntake
    }

    init(coreDataInterface: CoreDataInterfacing) {
        self.coreDataInterface = coreDataInterface
    }
    
    func save(record: WaterLogRecord) -> Result<Bool, Error> {
        guard record.isValid else { return .failure(WaterLoggingStoringError.invalidRecord)  }
        return coreDataInterface.save(record: record)
    }
}
