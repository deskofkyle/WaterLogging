//
//  CoreDataInterfacingError.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

enum CoreDataInterfacingError: Error {
    /// When the Core Data database fails to load the persistent store
    case failedToOpenDB
    /// When the database fails to execute a query
    case fetchFailure
    /// When the database fails to save the current context
    case saveContextFailure
}

extension CoreDataInterfacingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToOpenDB:
            return NSLocalizedString("Unable to open database.",
                                     comment: "")
        case .fetchFailure:
            return NSLocalizedString("Unable to fetch from database.",
                                     comment: "")
        case .saveContextFailure:
            return NSLocalizedString("Unable to save the database context.",
                                     comment: "")
        }
    }
}
