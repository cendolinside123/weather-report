//
//  WeatherDataSource.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import CoreData

struct WeatherDataSource {
    private let cdStack: CoreDataStack
    
    init(cdStack: CoreDataStack) {
        self.cdStack = cdStack
    }
}

extension WeatherDataSource: WeatherDataProvider {
    
    
    
}
