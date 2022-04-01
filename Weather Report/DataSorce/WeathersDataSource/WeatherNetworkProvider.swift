//
//  WeatherNetworkProvider.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

protocol WeatherNetworkProvider {
    func getWeather(lat: Double, lon: Double, exclude: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void)
}
