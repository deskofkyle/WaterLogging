//
//  WaterGoalsStorageSpec.swift
//  WaterLoggingTests
//
//  Created by Kyle Ryan on 8/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Quick
import Nimble

@testable import WaterLogging

class WaterGoalsStorageSpec: QuickSpec {
        
    override func spec() {
        var waterGoalsStorage: WaterGoalsStorage!
        
        describe("the WaterGoalsStorage") {
            beforeEach {
                waterGoalsStorage = WaterGoalsStorage(defaults: UserDefaults.standard)
                waterGoalsStorage.resetGoalToDefault()
            }
            
            context("when no goals are saved") {
                it("returns a default goal") {
                    expect(waterGoalsStorage.currentGoal.amount).to(equal(2500))
                }
            }
            
            context("when saving a new goal") {
                it("successfully saves the goal") {
                    let result = waterGoalsStorage.save(goal: WaterLogGoal(amount: 2500))
                    switch result {
                    case .success:
                        _ = succeed()
                    case .failure:
                        fail()
                    }
                }
            }
            
            context("after saving a goal") {
                beforeEach {
                    let result = waterGoalsStorage.save(goal: WaterLogGoal(amount: 1500))
                    switch result {
                    case .success:
                        break
                    case .failure:
                        break
                    }
                }
                
                it("updates the current goal") {
                    expect(waterGoalsStorage.currentGoal.amount).to(equal(1500))
                }
            }
        }
    }
}
