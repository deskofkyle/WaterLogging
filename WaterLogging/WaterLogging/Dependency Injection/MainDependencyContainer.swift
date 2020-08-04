//
//  MainDependencyContainer.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 7/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import HealthKit
import UIKit

final class MainDependencyContainer {
    static let shared = MainDependencyContainer()
}

extension MainDependencyContainer: TabBarControllerFactory {
    func makeAppTabBarController() -> UITabBarController {
        let trackWaterViewController = makeTrackWaterViewController()
        let visualizeWaterIntakeViewController = makeVisualizeWaterIntakeViewController()
        return AppTabBarController(trackWaterViewController: trackWaterViewController,
                                   visualizeWaterIntakeViewController: visualizeWaterIntakeViewController)
    }
}

extension MainDependencyContainer: TrackWaterViewControllerFactory {
    func makeTrackWaterViewController() -> TrackWaterViewController {
        let waterLoggingStorage = makeWaterLoggingStorage()
        let waterGoalsStorage = makeWaterGoalsStorage()
        return TrackWaterViewController(waterLoggingStorage: waterLoggingStorage,
                                        waterGoalsStorage: waterGoalsStorage)
    }
}

extension MainDependencyContainer: VisualizeWaterIntakeViewControllerFactory {
    func makeVisualizeWaterIntakeViewController() -> VisualizeWaterIntakeViewController {
        let waterLoggingStorage = makeWaterLoggingStorage()
        let waterGoalsStorage = makeWaterGoalsStorage()
        return VisualizeWaterIntakeViewController(waterLoggingStorage: waterLoggingStorage,
                                                  waterGoalsStorage: waterGoalsStorage)
    }
}

extension MainDependencyContainer: WaterLoggingStorageFactory {
    func makeWaterLoggingStorage() -> WaterLoggingStoring {
        let coreDataInterface = makeCoreDataInterface()
        return WaterLoggingStorage(coreDataInterface: coreDataInterface)
    }
}

extension MainDependencyContainer: CoreDataInterfaceFactory {
    func makeCoreDataInterface() -> CoreDataInterfacing {
        return CoreDataInterface(name: "WaterLoggingDataModel")
    }
}

extension MainDependencyContainer: WaterGoalsStorageFactory {
    func makeWaterGoalsStorage() -> WaterGoalsStoring {
        let defaults = UserDefaults.standard
        return WaterGoalsStorage(defaults: defaults)
    }
}

extension MainDependencyContainer: HealthQueryGeneratorFactory {
    func makeHealthQueryGenerator() -> HealthQuerying {
        let healthStore = HKHealthStore()
        let defaults = UserDefaults.standard
        return HealthQueryGenerator(healthStore: healthStore,
                                    defaults: defaults)
    }
}
