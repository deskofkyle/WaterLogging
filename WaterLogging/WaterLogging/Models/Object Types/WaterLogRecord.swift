//
//  WaterLogRecord.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension WaterLogRecord {
    private enum Constants {
        /// Represents the maxium water amount (mL) you can log at a single time for a day
        static let maxWaterAmount: Double = 5000
    }
    
    /**
     Determines if the record is valid and that it can successfully be entered into the database
     - The amount must be greater than zero
     - The amount is less than the `Constants.maxWaterAmount`
    */
    class func isValid(amount: Double) -> Bool {
        return amount != 0 &&
            amount <= Constants.maxWaterAmount
    }
}
