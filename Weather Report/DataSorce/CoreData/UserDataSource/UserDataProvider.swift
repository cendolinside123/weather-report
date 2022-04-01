//
//  UserDataProvider.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

protocol UserDataProvider {
    func createUser(user getUser: UserInfo, completion: @escaping (NetworkResult<UserInfo>) -> Void)
    func findSpesificUser(user getUser: UserInfo, completion: @escaping (NetworkResult<User>) -> Void)
    func findUser(user getUser: UserInfo, completion: @escaping (NetworkResult<User>) -> Void)
    func deleteUser(user getUser: UserInfo, completion: @escaping (NetworkResult<UserInfo>) -> Void)
}
