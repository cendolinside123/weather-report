//
//  TestDataLoad.swift
//  Weather ReportTests
//
//  Created by Jan Sebastian on 30/03/22.
//

import Foundation
import XCTest
import CoreData
@testable import Weather_Report

class TestDataLoad: XCTestCase {
    var viewModel: WeatherVMGuideline?
    
    
    func testLoad() {
        
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let cdStack = CoreDataStack(modelName: "Weather_Report")
        cdStack.getStoreContainer().persistentStoreDescriptions = [persistentStoreDescription]
        
        let useCase = WeatherUseCase(weatherOnlineRequest: WeathersDataProvider(), weatherLocalData: WeatherDataSource(cdStack: cdStack), userLocalData: UserDataSource(cdStack: cdStack), locationLocalData: LocationDataSource(cdStack: cdStack))
        viewModel = WeatherViewModel(useCase: useCase)
        let loadExpectation = expectation(description: "should return list of weather")
        viewModel?.dataResponse = { [weak self] _ in
            XCTAssertGreaterThan(self?.viewModel?.listData.count ?? 0, 0)
            loadExpectation.fulfill()
        }
        viewModel?.errorReponse = { error in
            print("error: \(error.localizedDescription)")
            XCTAssert(false)
        }
        
        viewModel?.getWeather(lat: 33.44, lon: -94.04, exclude: [Exclude.current.rawValue, Exclude.hourly.rawValue], user: UserInfo(name: "guest", pass: "guest", isGuest: true), reload: 3)
        
        wait(for: [loadExpectation], timeout: 5)
        
    }
    
    
}
