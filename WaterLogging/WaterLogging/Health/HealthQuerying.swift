//
//  HealthQuerying.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

protocol HealthQuerying {
    func authorizeHealth(completion: @escaping (Result<Bool, HealthQueryingError>) -> Void)
    func queryCurrentWeight()
}
