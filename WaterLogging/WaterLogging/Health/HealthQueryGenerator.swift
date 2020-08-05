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
        static let hasRequestedAuthorizationKey = "com.WaterLogging.hasRequestedAuthorization"
        static let canQueryWeightKey = "com.WaterLogging.canQueryWeight"
    }
    
    /// Determines if the user has authorized all HealthKit permissions
    var hasRequestedAuthorization: Bool {
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: Constants.hasRequestedAuthorizationKey)
        }
        
        get {
            return UserDefaults.standard.bool(forKey: Constants.hasRequestedAuthorizationKey)
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
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(.healthNotAvailable))
            return
        }

        guard !hasRequestedAuthorization else {
            completion(.failure(.alreadyRequested))
            return
        }
        
        let bodyMass = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!])

        healthStore.requestAuthorization(toShare: [], read: bodyMass) { [weak self] (canQueryWeight, error) in
            guard let self = self else { return }
            self.hasRequestedAuthorization = true
            DispatchQueue.main.async {
                completion(.success((canQueryWeight)))
            }
        }
    }

    // Citation on queries:
    // https://developer.apple.com/documentation/healthkit/reading_data_from_healthkit
    func queryCurrentWeight(completion: @escaping (Result<UserWeight, HealthQueryingError>) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(.healthNotAvailable))
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                  predicate: nil,
                                  limit: 1,
                                  sortDescriptors: [sortDescriptor]) { (query, results, error) in
                                    
                                    guard error == nil else {
                                        DispatchQueue.main.async {
                                            completion(.failure(HealthQueryingError.queryFailure(error: error)))
                                        }
                                        return
                                    }
                                    
                                    guard let results = results,
                                        let mostRecentSample = results.last as? HKQuantitySample else {
                                            DispatchQueue.main.async {
                                                completion(.failure(HealthQueryingError.noDataAvailable))
                                            }
                                            return
                                    }
                                    
                                    let pounds = mostRecentSample.quantity.doubleValue(for: .pound())
                                    DispatchQueue.main.async {
                                        let weight = UserWeight(pounds: pounds)
                                        completion(.success(weight))
                                    }
                                    
        }
        healthStore.execute(query)
    }
}
