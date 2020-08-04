//
//  CircularProgressViewModel.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

struct CircularProgressViewModel {
    let color: UIColor
    let currentValue: Double
    let maxValue: Double
    
    var progress: Float {
        let result = currentValue / maxValue
        return Float(result.isNaN ? 0 : result)
    }
}
