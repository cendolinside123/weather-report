//
//  User+CoreDataProperties.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String
    @NSManaged public var password: String
    @NSManaged public var isGuest: Bool
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for user
extension User {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: Location)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: Location)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}
