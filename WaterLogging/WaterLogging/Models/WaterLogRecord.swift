//
//  WaterLogRecord.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct WaterLogRecord {
    private enum Constants {
        /// Represents the maxium water amount (mL) you can log at a single time for a day
        static let maxWaterAmount: Double = 5000
    }

    let amount: Double
    let createdAt: Date
    let lastUpdated: Date
    
    /**
     Determines if the record is valid and that it can successfully be entered into the database
     - The amount must be greater than zero
     - The amount is less than the `Constants.maxWaterAmount`
     - It must be created at a past date
     - It must be last updated at a past date
    */
    var isValid: Bool {
        return amount != 0 &&
            amount <= Constants.maxWaterAmount &&
            createdAt <= Date() &&
            lastUpdated <= Date()
    }
}
