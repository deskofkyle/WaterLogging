//
//  WaterLoggingScenesFactory.swift
//  WaterLoggingScenes
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import WaterLoggingDatabase

public final class WaterLoggingScenesFactory {
    public static let shared = WaterLoggingScenesFactory()
}

extension WaterLoggingScenesFactory: TabBarControllerFactory {
    public func makeAppTabBarController() -> UITabBarController {
        let trackWaterViewController = makeTrackWaterViewController()
        return AppTabBarController(trackWaterViewController: trackWaterViewController)
    }
}

extension WaterLoggingScenesFactory: ViewControllerFactory {
    public func makeTrackWaterViewController() -> TrackWaterViewController {
        let waterLoggingStorage = WaterLoggingDatabaseFactory.shared.makeWaterLoggingStorage()
        return TrackWaterViewController(waterLoggingStorage: waterLoggingStorage)
    }
    
    public func makeVisualizeWaterIntakeViewController() -> VisualizeWaterIntakeViewController {
        return VisualizeWaterIntakeViewController()
    }
}
