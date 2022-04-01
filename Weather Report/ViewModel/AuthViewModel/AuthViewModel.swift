//
//  AuthViewModel.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

class AuthViewModel {
    private var useCase: UserDataProvider?
    var errorReponse: ((Error) -> Void)?
    var loginResponse: ((UserInfo) -> Void)?
    var authResponse: ((UserInfo) -> Void)?
    
    init(useCase: UserDataProvider) {
        self.useCase = useCase
    }
    
}

extension AuthViewModel: AuthVMGuideline {
    func createUser(user data: UserInfo) {
        
        let dispatchGroup = DispatchGroup()
        var errorMessage: Error?
        dispatchGroup.enter()
        self.useCase?.findUser(user: data, completion: { response in
            switch response {
            case .success(_):
                break
            case .failed(let error):
                errorMessage = error
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            if errorMessage != nil {
                self?.useCase?.createUser(user: data, completion: { [weak self] response in
                    switch response {
                    case .success(let result):
                        self?.authResponse?(result)
                    case .failed(let error):
                        self?.errorReponse?(error)
                    }
                })
            } else {
                self?.errorReponse?(userResponse.registered)
            }
            
        })
        
    }
    
    func loginUser(user data: UserInfo) {
        self.useCase?.findSpesificUser(user: data, completion: { [weak self] response in
            switch response {
            case .success(let user):
                let userName = user.username
                let password = user.password
                let isGuest = user.isGuest
                let inputUser = UserInfo(name: userName, pass: password, isGuest: isGuest)
                _ = UserSession.saveUser(user: inputUser)
                self?.loginResponse?(inputUser)
            case .failed(let error):
                self?.errorReponse?(error)
            }
        })
    }
    
    func logout() {
        UserSession.deleteUser()
    }
    
    func deleteUser(user data: UserInfo) {
        self.useCase?.deleteUser(user: data, completion: { [weak self] response in
            switch response {
            case .success(let data):
                UserSession.deleteUser()
                self?.authResponse?(data)
            case .failed(let error):
                self?.errorReponse?(error)
            }
        })
    }
    
    
}

struct UserSession {
    static func deleteUser() {
        UserDefaults.standard.removeObject(forKey: Constants.userDefaults.userSession)
    }
    
    static func saveUser(user data: UserInfo) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            UserDefaults.standard.set(data, forKey: Constants.userDefaults.userSession)
            return true
        } catch let error {
            print("error save user info: \(error)")
            return false
        }
    }
    
    static func getUser() -> UserInfo? {
        do {
            if let data = UserDefaults.standard.data(forKey: Constants.userDefaults.userSession) {
                let decoder = JSONDecoder()
                let getUser = try decoder.decode(UserInfo.self, from: data)
                return getUser
            } else {
                return nil
            }
        } catch let error {
            print("error save user info: \(error)")
            return nil
        }
    }
}
