//
//  AuthVMGuideline.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation


protocol AuthVMGuideline {
    func createUser(user data: UserInfo)
    func loginUser(user data: UserInfo)
    func logout()
    func deleteUser(user data: UserInfo)
    var errorReponse: ((Error) -> Void)? { get set }
    var loginResponse: ((UserInfo) -> Void)? { get set }
    var authResponse: ((UserInfo) -> Void)? { get set }
}


