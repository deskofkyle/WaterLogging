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
        }
    }
}
