//
//  WaterGoalGeneratorSpec.swift
//  WaterLoggingTests
//
//  Created by Kyle Ryan on 8/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Quick
import Nimble

@testable import WaterLogging

class WaterGoalGeneratorSpec: QuickSpec {
        
    override func spec() {
        var waterGoalGenerator: WaterGoalGenerator!
        var mockHealthQueryGenerator: MockHealthQueryGenerator!

        describe("WaterGoalGenerator") {
            context("when not authorized with Health") {
                context("when Health querying succeeds") {
                    beforeEach {
                        mockHealthQueryGenerator = MockHealthQueryGenerator(hasRequestedAuthorization: false,
                                                                            shouldSucceed: true)
                        waterGoalGenerator = WaterGoalGenerator(healthQueryGenerator: mockHealthQueryGenerator)
                    }

                    it("will not be able to generate a goal") {
                        expect(waterGoalGenerator.canGenerateGoal).to(beFalse())
                    }
                    
                    it("returns a water goal equal using the rule-of-thumb formula") {
                        let calculatedGoal = waterGoalGenerator.waterGoal(from: UserWeight(pounds: 145))
                        expect(calculatedGoal.amount).to(equal(2144))
                    }
                    
                    context("when generating a water goal after authorizing with Health") {
                        it("will use Health data") {
                            
                            mockHealthQueryGenerator.authorizeHealth { (result) in
                                switch result {
                                case .success(let didAuthorize):
                                    expect(didAuthorize).to(beTrue())
                                    
                                    waterGoalGenerator.generateWaterGoal { (result) in
                                        switch result {
                                        case .success(let newGoal):
                                            expect(newGoal.amount).to(equal(2144))
                                        case .failure:
                                            fail()
                                        }
                                    }
                                case .failure:
                                    fail()
                                }
                            }
                        }
                    }
                    
                    context("when generating a water goal and unauthorized with Health") {
                        it("cannot use HealthKit data") {
                            waterGoalGenerator.generateWaterGoal { (result) in
                                switch result {
                                case .success:
                                    fail()
                                case .failure(let error):
                                    expect(error).to(equal(WaterGoalGeneratingError.healthUnavailable))
                                }
                            }
                        }
                    }
                }
                
                context("when Health querying fails") {
                    beforeEach {
                        mockHealthQueryGenerator = MockHealthQueryGenerator(hasRequestedAuthorization: false,
                                                                            shouldSucceed: false)
                        waterGoalGenerator = WaterGoalGenerator(healthQueryGenerator: mockHealthQueryGenerator)
                    }

                    it("will not be able to generate a goal") {
                        expect(waterGoalGenerator.canGenerateGoal).to(beFalse())
                    }
                    
                    it("returns a water goal equal using the rule-of-thumb formula") {
                        let calculatedGoal = waterGoalGenerator.waterGoal(from: UserWeight(pounds: 145))
                        expect(calculatedGoal.amount).to(equal(2144))
                    }
                    
                    context("when generating a water goal") {
                        it("fails to use HealthKit data") {
                            waterGoalGenerator.generateWaterGoal { (result) in
                                switch result {
                                case .success:
                                    fail()
                                case .failure(let error):
                                    expect(error).to(equal(WaterGoalGeneratingError.healthUnavailable))
                                }
                            }
                        }
                    }
                }
            }
            
            context("when authorized with Health") {
                beforeEach {
                    mockHealthQueryGenerator = MockHealthQueryGenerator(hasRequestedAuthorization: true,
                                                                        shouldSucceed: true)
                    waterGoalGenerator = WaterGoalGenerator(healthQueryGenerator: mockHealthQueryGenerator)
                }

                it("can generate a goal") {
                    expect(waterGoalGenerator.canGenerateGoal).to(beTrue())
                }
                
                it("returns a water goal equal using the rule-of-thumb formula") {
                    let calculatedGoal = waterGoalGenerator.waterGoal(from: UserWeight(pounds: 145))
                    expect(calculatedGoal.amount).to(equal(2144))
                }
            }
        }
    }
}

final class MockHealthQueryGenerator: HealthQuerying {

    var hasRequestedAuthorization: Bool
    let shouldSucceed: Bool

    init(hasRequestedAuthorization: Bool, shouldSucceed: Bool) {
        self.hasRequestedAuthorization = hasRequestedAuthorization
        self.shouldSucceed = shouldSucceed
    }
    
    func authorizeHealth(completion: @escaping (Result<Bool, HealthQueryingError>) -> Void) {
        if shouldSucceed {
            hasRequestedAuthorization = true
            completion(.success(true))
        } else {
            completion(.failure(.healthNotAvailable))
        }
    }
    
    func queryCurrentWeight(completion: @escaping (Result<UserWeight, HealthQueryingError>) -> Void) {
        if shouldSucceed && hasRequestedAuthorization {
            completion(.success(UserWeight(pounds: 145)))
        } else {
            completion(.failure(.queryFailure(error: nil)))
        }
    }
}
