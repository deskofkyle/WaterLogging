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
        // Reference: https://www.asknumbers.com/oz-to-ml.aspx#:~:text=1%20Fluid%20ounce%20(oz)%20is,473.176473%20mL%20is%2016%20oz.
        static let ouncesToMillilitersRatio: Double = 29.5735296
    }
    
    // Reference: https://www.nature.com/articles/ejcn2012157
    //    Original water requirement studies are between 60 and 100 years old. Commonly published water requirement equations are based on just a few historical studies that do not satisfy more rigorous modern scientific method. Practitioners would be prudent to use water requirement equations as a guide only while employing additional means (such as monitoring short-term weight changes, physical or biochemical parameters and urine output volumes) to ensure the adequacy of water provision in clinical care or health-care settings.
    
    // https://www.umsystem.edu/totalrewards/wellness/how-to-calculate-how-much-water-you-should-drink
//    Your weight is one variable that changes the amount of water you should be drinking. To help you establish a baseline, you can use the following rule-of-thumb equation. In short, the equation tells you to take half your body weight, and drink that amount in ounces of water. In the example, notice that you should be drinking more than 12 glasses of water, not eight!
    
    var canGenerateGoal: Bool {
        return healthQueryGenerator.hasGrantedPermission
    }
    
    private let healthQueryGenerator: HealthQuerying
    
    init(healthQueryGenerator: HealthQuerying) {
        self.healthQueryGenerator = healthQueryGenerator
    }

    func generateWaterGoal(completion: @escaping (Result<WaterLogGoal, WaterGoalGeneratingError>) -> Void) {
        healthQueryGenerator.queryCurrentWeight { result in
            switch result {
            case .success(let weight):
                let ouncesGoal = weight / 2
                let milliLitersGoal = ouncesGoal * Constants.ouncesToMillilitersRatio
                completion(.success(WaterLogGoal(amount: milliLitersGoal)))
            case .failure:
                completion(.failure(WaterGoalGeneratingError.healthUnavailable))
            }
        }
    }
}
