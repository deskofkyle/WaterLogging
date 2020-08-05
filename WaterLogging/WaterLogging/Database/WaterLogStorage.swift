//
//  WaterLogStorage.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterLoggingStoring {
    var todaysWaterIntake: Result<WaterLogProgress, WaterLoggingStoringError> { get }
    func save(amount: Double) -> Result<Void, WaterLoggingStoringError>
}

protocol WaterLoggingStorageFactory {
    func makeWaterLoggingStorage() -> WaterLoggingStoring
}

final class WaterLoggingStorage: WaterLoggingStoring {
    
    private let coreDataInterface: CoreDataInterfacing
    
    /// Returns the sum of that water in-take for today's date
    var todaysWaterIntake: Result<WaterLogProgress, WaterLoggingStoringError> {
        switch coreDataInterface.todaysWaterIntake {
        case .success(let progress):
            return .success(progress)
        case .failure(let error):
            return .failure(.fetchFailure(error: error))
        }
    }

    init(coreDataInterface: CoreDataInterfacing) {
        self.coreDataInterface = coreDataInterface
    }
    
    func save(amount: Double) -> Result<Void, WaterLoggingStoringError> {
        guard WaterLogRecord.isValid(amount: amount) else { return .failure(WaterLoggingStoringError.invalidRecord)  }
        switch coreDataInterface.save(amount: amount) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(.saveFailure(error: error))
        }
    }
}
