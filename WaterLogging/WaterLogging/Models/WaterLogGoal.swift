//
//  WaterLogGoal.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct WaterLogGoal {
    private enum Constants {
        /// Represents the maxium water amount (mL) you can set as a goal
        static let maxWaterGoal = 6000
    }

    /// A water goal amount (mL)
    let amount: Int

    /**
     Determines if the goal is valid and that it can successfully be saved to User Defaults
     - The amount must be greater than zero
     - The amount is less than the `Constants.maxWaterGoal`
     - It must be created at a past date
     - It must be last updated at a past date
    */
    var isValid: Bool {
        return amount != 0 &&
            amount <= Constants.maxWaterGoal
    }
}
