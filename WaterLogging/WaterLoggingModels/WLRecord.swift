//
//  WLRecord.swift
//  WaterLoggingModels
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

public struct WLRecord {
    public let amount: Double
    public let createdAt: Date
    public let lastUpdated: Date
    public let unit: WLUnit
    
    public init(amount: Double, createdAt: Date, lastUpdated: Date, unit: WLUnit) {
        self.amount = amount
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
        self.unit = unit
    }
}
