//
//  WaterGoalGenerator.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol WaterGoalGeneratorFactory {
    func makeWaterGoalGenerator() -> WaterGoalGenerating
}

struct WaterGoalGenerator: WaterGoalGenerating {
    
    private enum Constants {
        // Citation: https://www.asknumbers.com/oz-to-ml.aspx#:~:text=1%20Fluid%20ounce%20(oz)%20is,473.176473%20mL%20is%2016%20oz.
        static let ouncesToMillilitersRatio: Double = 29.5735296
    }
    
    var canGenerateGoal: Bool {
        return healthQueryGenerator.hasRequestedAuthorization
    }
    
    private let healthQueryGenerator: HealthQuerying
    
    init(healthQueryGenerator: HealthQuerying) {
        self.healthQueryGenerator = healthQueryGenerator
    }

    func generateWaterGoal(completion: @escaping (Result<WaterLogGoal, WaterGoalGeneratingError>) -> Void) {
        healthQueryGenerator.queryCurrentWeight { result in
            switch result {
            case .success(let weight):
                completion(.success(self.waterGoal(from: weight)))
            case .failure:
                completion(.failure(WaterGoalGeneratingError.healthUnavailable))
            }
        }
    }
 
    /// Calulates a general water goal (`WaterLogGoal` from a given weight in pounds (lbs).
    /// This calculation is based on "rule of thumb" water intake recommendations based on weight. (See: https://www.umsystem.edu/totalrewards/wellness/how-to-calculate-how-much-water-you-should-drink)
    /// From other research (See: https://www.nature.com/articles/ejcn2012157), ideal water intake is based on a number of factors like gender, level of activity, diet, etc. There is no empirically backed water intake estimation formula based on weight alone.  "Rule of thumb" measurements should not be relied upon as a medical recommendation. Patients should work with their providers to understand how much water they should drink per day.
    /// This formula represents the "Rule of Thumb" calculation which take a weight in pounds (lbs), divided by two to represent the amount of water you should drink in ounces. This measurement then needs to be converted to milliliters (mL).
    func waterGoal(from weight: UserWeight) -> WaterLogGoal {
        let ouncesGoal = weight.pounds / 2
        let goalsInMilliliters = Int(ouncesGoal * Constants.ouncesToMillilitersRatio)
        return WaterLogGoal(amount: goalsInMilliliters)
    }
}
