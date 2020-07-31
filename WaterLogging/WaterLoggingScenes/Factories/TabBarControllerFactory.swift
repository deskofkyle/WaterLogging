//
//  TabBarControllerFactory.swift
//  WaterLoggingScenes
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

public protocol TabBarControllerFactory {
    func makeAppTabBarController() -> UITabBarController
}
