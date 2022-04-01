//
//  WeatherVMGuideline.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

protocol WeatherVMGuideline {
    func getWeather(lat getLat: Double, lon getLon: Double, exclude getExclude: [String], user data: UserInfo, reload time: Int)
    var listData: [CurrentLocation] { get set }
    var dataResponse: (([CurrentLocation]) -> Void)? { get set }
    var errorReponse: ((Error) -> Void)? { get set }
    var cacheResponse: (([CurrentLocation]) -> Void)? { get set }
}

struct WeatherUseCase {
    let weatherOnlineRequest: WeatherNetworkProvider
    let userLocalData: UserDataProvider
    let locationLocalData: LocationDataProvider
}
