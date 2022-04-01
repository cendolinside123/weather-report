//
//  Location+CoreDataProperties.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var dt: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var timezone: String
    @NSManaged public var pressure: Int64
    @NSManaged public var humidity: Int64
    @NSManaged public var wind_speed: Double
    @NSManaged public var item: User?
    @NSManaged public var category: String
    @NSManaged public var weather: NSSet?

}

// MARK: Generated accessors for weather
extension Location {

    @objc(addWeatherObject:)
    @NSManaged public func addToWeather(_ value: Weather)

    @objc(removeWeatherObject:)
    @NSManaged public func removeFromWeather(_ value: Weather)

    @objc(addWeather:)
    @NSManaged public func addToWeather(_ values: NSSet)

    @objc(removeWeather:)
    @NSManaged public func removeFromWeather(_ values: NSSet)

}
