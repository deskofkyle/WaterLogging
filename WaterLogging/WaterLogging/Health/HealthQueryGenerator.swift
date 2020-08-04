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
    var hasGrantedPermission: Bool {
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

    // Citation:
    // https://developer.apple.com/documentation/healthkit/authorizing_access_to_health_data
    // Referenced the authorization of HealthKit documentation
    func authorizeHealth(completion: @escaping (Result<Bool, HealthQueryingError>) -> Void) {
        guard !hasGrantedPermission else {
            completion(.failure(.permissionExpired))
            return
        }
        
        let bodyMass = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!])

        healthStore.requestAuthorization(toShare: [], read: bodyMass) { [weak self] (success, error) in
            guard let self = self else { return }

            guard success else {
                DispatchQueue.main.async {
                    completion(.failure(.userDenied))
                }
                return
            }
            
            self.hasGrantedPermission = true
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }

    // Citation on queries:
    // https://developer.apple.com/documentation/healthkit/reading_data_from_healthkit
    func queryCurrentWeight(completion: @escaping (Result<Double, HealthQueryingError>) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { (query, results, error) in
                                    
                                    guard error != nil else {
                                        DispatchQueue.main.async {
                                            completion(.failure(HealthQueryingError.queryFailure))
                                        }
                                        return
                                    }
                                    
                                    guard let results = results,
                                        let mostRecentSample = results.first as? HKQuantitySample else {
                                            DispatchQueue.main.async {
                                                completion(.failure(HealthQueryingError.noDataAvailable))
                                            }
                                            return
                                    }
                                    
                                    let weight = mostRecentSample.quantity.doubleValue(for: .pound())
                                    DispatchQueue.main.async {
                                        completion(.success(weight))
                                    }
                                    
        }
        healthStore.execute(query)
    }
}
