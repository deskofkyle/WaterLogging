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
    let currentValue: Int
    let maxValue: Int
    
    var progress: Double {
        let result = Double(currentValue) / Double(maxValue)
        return Double(result.isNaN ? 0 : result)
    }
}
