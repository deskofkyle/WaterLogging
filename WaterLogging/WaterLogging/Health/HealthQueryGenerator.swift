//
//  HealthQueryGenerator.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthQueryGeneratorFactory {
    func makeHealthQueryGenerator() -> HealthQuerying
}

final class HealthQueryGenerator: HealthQuerying {
    
    private enum Constants {
        static let hasGrantedPermissionKey = "com.WaterLogging.hasHealthPermissionEnabled"
    }
    
    /// Determines if the user has authorized all HealthKit permissions
    private var hasGrantedPermission: Bool {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: Constants.hasGrantedPermissionKey)
        }
        
        get {
            return UserDefaults.standard.bool(forKey: Constants.hasGrantedPermissionKey)
        }
    }
    
    private let healthStore: HKHealthStore
    private let defaults: UserDefaults

    init(healthStore: HKHealthStore,
         defaults: UserDefaults) {
        self.healthStore = healthStore
        self.defaults = defaults
    }

    func authorizeHealth(completion: @escaping (Result<Bool, HealthQueryingError>) -> Void) {
        guard !hasGrantedPermission else { return }
        
        let bodyMass = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!])

        healthStore.requestAuthorization(toShare: [], read: bodyMass) { [weak self] (success, error) in
            guard let self = self else { return }

            guard success else {
                completion(.failure(.userDenied))
                return
            }
            
            if (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier:.bodyMass)!) == .sharingAuthorized) {
                self.hasGrantedPermission = true
                completion(.success(true))
            } else {
                self.hasGrantedPermission = false
                completion(.success(false))
            }
        }
    }

    func queryCurrentWeight() {
        
    }
}
