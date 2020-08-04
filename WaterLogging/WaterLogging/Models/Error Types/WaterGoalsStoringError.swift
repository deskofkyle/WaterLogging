//
//  WaterGoalsStoringError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum WaterGoalsStoringError: Error {
    /// This `WaterLogGoal`  does not pass `WaterLogGoal.isValid` validation.
    case invalidGoal
}

extension WaterGoalsStoringError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidGoal:
            return NSLocalizedString("The goal value must be greater than zero and less than 5000 mL.",
                                     comment: "")
        }
    }
}
