//
//  WaterGoalGeneratingError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum WaterGoalGeneratingError: Error {
    /// This device does not support HealthKit (like iPad)
    case healthUnavailable
}

extension WaterGoalGeneratingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .healthUnavailable:
            return NSLocalizedString("There was an error reading from Health. Please enable this app's access to health data in Settings > Privacy > Health > WaterLogging.",
                                     comment: "")
        }
    }
}
