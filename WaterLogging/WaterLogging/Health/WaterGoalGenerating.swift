//
//  WaterGoalGenerating.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterGoalGenerating {
    /// Determines if a goal can be generated from Health data
    var canGenerateGoal: Bool { get }
    /// Takes a user's weight in pounds and generates a `WaterLogGoal`
    func generateWaterGoal(completion: @escaping (Result<WaterLogGoal, WaterGoalGeneratingError>) -> Void)
}
