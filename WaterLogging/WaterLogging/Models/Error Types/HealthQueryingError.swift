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
    /// The user already requested access to HealthKit
    case alreadyRequested
    /// Permissions denied
    case permissionDenied
    /// Query failure
    case queryFailure(error: Error?)
    /// No data available
    case noDataAvailable
}

extension HealthQueryingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .healthNotAvailable:
            return NSLocalizedString("Health is not available on this device.",
                                     comment: "")
        case .alreadyRequested:
            return NSLocalizedString("Health authorization has already been requested. You can change this app's access to health data in Settings > Privacy > Health > WaterLogging",
                                     comment: "")
        case .permissionDenied:
            return NSLocalizedString("Access to read weight from HealthKit was denied",
                                     comment: "")
        case .queryFailure(let error):
            return NSLocalizedString("Query to health did not succeed. \(error?.localizedDescription ?? "Unknown")",
                                     comment: "")
        case .noDataAvailable:
            return NSLocalizedString("No health data available.",
                                     comment: "")
        }
    }
}
