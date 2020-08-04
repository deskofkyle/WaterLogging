//
//  WaterLoggingStoringError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum WaterLoggingStoringError: Error {
    /// This `WaterLogRecord`  does not pass `WaterLogRecord.isValid` validation.
    case invalidRecord
}

extension WaterLoggingStoringError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRecord:
            return NSLocalizedString("The saved value must be greater than zero and less than 5000 mL.",
                                     comment: "")
        }
    }
}
