//
//  Weather+CoreDataProperties.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var id: Int64
    @NSManaged public var main: String
    @NSManaged public var desc: String
    @NSManaged public var parentInfo: Location?

}
