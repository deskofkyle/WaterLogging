//
//  WaterGoalsStorage.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterGoalsStoring {
    var currentGoal: WaterLogGoal { get }
    func save(goal: WaterLogGoal)
}

protocol WaterGoalsStorageFactory {
    func makeWaterGoalsStorage() -> WaterGoalsStoring
}

struct WaterGoalsStorage: WaterGoalsStoring {
    
    private enum Constants {
        static let goalsStorageKey = "com.WaterLogging.currentGoal"
        static let defaultGoal = WaterLogGoal(amount: 2500)
    }
    
    private let defaults: UserDefaults
    
    /// Provides the current goal value from user detaults if one is set. If not, it will return the default goal.
    var currentGoal: WaterLogGoal {
        let savedValue = defaults.double(forKey: Constants.goalsStorageKey)
        return savedValue == 0 ?
            Constants.defaultGoal :
            WaterLogGoal(amount: savedValue)
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func save(goal: WaterLogGoal) {
        defaults.setValue(goal.amount,
                          forKey: Constants.goalsStorageKey)
    }
}
