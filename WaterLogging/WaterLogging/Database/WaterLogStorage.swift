//
//  WaterLogStorage.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterLoggingStoring {
    var todaysWaterIntake: Result<Int, Error> { get }
    func save(amount: Double) -> Result<Bool, Error>
}

protocol WaterLoggingStorageFactory {
    func makeWaterLoggingStorage() -> WaterLoggingStoring
}

final class WaterLoggingStorage: WaterLoggingStoring {
    
    private let coreDataInterface: CoreDataInterfacing
    
    /// Returns the sum of that water in-take for today's date
    var todaysWaterIntake: Result<Int, Error> {
        return coreDataInterface.todaysWaterIntake
    }

    init(coreDataInterface: CoreDataInterfacing) {
        self.coreDataInterface = coreDataInterface
    }
    
    func save(amount: Double) -> Result<Bool, Error> {
        guard WaterLogRecord.isValid(amount: amount) else { return .failure(WaterLoggingStoringError.invalidRecord)  }
        return coreDataInterface.save(amount: amount)
    }
}
