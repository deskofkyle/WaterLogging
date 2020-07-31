//
//  WaterLoggingFactory.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WaterLoggingScenes

final class WaterLoggingFactory {
    static let shared = WaterLoggingFactory()
}

extension WaterLoggingFactory: TabBarControllerFactory {
    func makeAppTabBarController() -> UITabBarController {
        return WaterLoggingScenesFactory.shared.makeAppTabBarController()
    }
}
