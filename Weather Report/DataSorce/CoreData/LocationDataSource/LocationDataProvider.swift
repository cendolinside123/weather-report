//
//  LocationDataProvider.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

protocol LocationDataProvider {
    func getLocation(user getUser: User, exclude getCategory: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void)
    func addLocation(user getUser: UserInfo, location getLocation: CurrentLocation, completion: @escaping (NetworkResult<CurrentLocation>) -> Void )
    func getLocation(user getUser: UserInfo, exclude getCategory: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void)
    func addLocation(user getUser: UserInfo, location getLocation: [CurrentLocation], completion: @escaping () -> Void )
}
