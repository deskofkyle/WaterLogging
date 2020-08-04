//
//  HealthQueryingError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum HealthQueryingError: Error {
    /// This device does not support HealthKit (like iPad)
    case healthNotAvailable
    /// The user denied access to HealthKit
    case userDenied
    /// Query failure
    case queryFailure
    /// No data available
    case noDataAvailable
    /// User has already seen the Health permission screen, so we should not show it again
    case permissionExpired
}

extension HealthQueryingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .healthNotAvailable:
            return NSLocalizedString("Health is not available on this device.",
                                     comment: "")
        case .userDenied:
            return NSLocalizedString("Permission to access Health was denied.",
                                     comment: "")
        case .queryFailure:
            return NSLocalizedString("Query to health did not succeed.",
                                     comment: "")
        case .noDataAvailable:
            return NSLocalizedString("No health data available.",
                                     comment: "")
        case .permissionExpired:
            return NSLocalizedString("Health authorization has already been requested. You can change this apps access to health data in Settings > Privacy > Health > WaterLogging",
                                     comment: "")
        }
    }
}
