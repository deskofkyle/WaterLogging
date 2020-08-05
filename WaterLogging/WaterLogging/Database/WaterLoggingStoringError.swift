//
//  WaterLoggingStoringError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum WaterLoggingStoringError: Error {
    /// When we are unable to fetch from Core Data
    case fetchFailure(error: CoreDataInterfacingError)
    /// When we are unable to save to Core Data
    case saveFailure(error: CoreDataInterfacingError)
    /// This `WaterLogRecord`  does not pass `WaterLogRecord.isValid(amount: Double)` validation.
    case invalidRecord
}

extension WaterLoggingStoringError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRecord:
            return NSLocalizedString("The saved value must be greater than zero and less than 5000 mL.",
                                     comment: "")
        case .saveFailure(let error):
            return NSLocalizedString("Unable to save watch intake. \(error.localizedDescription)",
                                     comment: "")
        case .fetchFailure(let error):
            return NSLocalizedString("Unable to fetch water intake. \(error.localizedDescription)",
                comment: "")
        }
    }
}
