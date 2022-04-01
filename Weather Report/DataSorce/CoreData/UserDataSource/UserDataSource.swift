//
//  UserDataSource.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import CoreData

struct UserDataSource {
    private let cdStack: CoreDataStack
    
    init(cdStack: CoreDataStack) {
        self.cdStack = cdStack
    }
}

extension UserDataSource: UserDataProvider {
    func createUser(user getUser: UserInfo, completion: @escaping (NetworkResult<UserInfo>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            do {
                let inputUser = User(context: context)
                inputUser.username = getUser.name
                inputUser.password = getUser.pass
                inputUser.isGuest = getUser.isGuest
                try context.save()
                completion(.success(getUser))
                
            } catch let error as NSError {
                completion(.failed(error))
            }
        })
    }
    
    func findSpesificUser(user getUser: UserInfo, completion: @escaping (NetworkResult<User>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            
            let predicateUserName: NSPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\User.username)._kvcKeyPathString!)
            let predicatePassword: NSPredicate = NSPredicate(format: "%K == '\(getUser.pass)'", (\User.password)._kvcKeyPathString!)
            let allPredicate: NSCompoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateUserName, predicatePassword])
            
            let fetchUser: NSFetchRequest<User> = User.fetchRequest()
            fetchUser.predicate = allPredicate
            
            do {
                if let getSelectedUser = try context.fetch(fetchUser).first {
                    completion(.success(getSelectedUser))
                } else {
                    throw ErrorResponse.notFound
                }
                
            } catch let error as NSError {
                completion(.failed(error))
            }
        })
    }
    
    func findUser(user getUser: UserInfo, completion: @escaping (NetworkResult<User>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            
            let predicateUserName: NSPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\User.username)._kvcKeyPathString!)
            
            let fetchUser: NSFetchRequest<User> = User.fetchRequest()
            fetchUser.predicate = predicateUserName
            
            do {
                if let getSelectedUser = try context.fetch(fetchUser).first {
                    completion(.success(getSelectedUser))
                } else {
                    throw ErrorResponse.notFound
                }
                
            } catch let error as NSError {
                completion(.failed(error))
            }
        })
    }
    
    func deleteUser(user getUser: UserInfo, completion: @escaping (NetworkResult<UserInfo>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            self.cdStack.doInBackground(managedContext: { context in
                
                let predicateUserName: NSPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\User.username)._kvcKeyPathString!)
                let predicatePassword: NSPredicate = NSPredicate(format: "%K == '\(getUser.pass)'", (\User.password)._kvcKeyPathString!)
                let allPredicate: NSCompoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [predicateUserName, predicatePassword])
                
                let fetchUser: NSFetchRequest<User> = User.fetchRequest()
                fetchUser.predicate = allPredicate
                
                do {
                    if let getSelectedUser = try context.fetch(fetchUser).first {
                        context.delete(getSelectedUser)
                        try context.save()
                        completion(.success(getUser))
                    } else {
                        throw ErrorResponse.notFound
                    }
                    
                } catch let error as NSError {
                    completion(.failed(error))
                }
            })
        })
    }
    
    
}
