//
//  Weathers.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import SwiftyJSON

struct Weathers {
    let id: Int
    let main: String
    let description: String
}

extension Weathers {
    init(get json: JSON) {
        id = json["id"].intValue
        main = json["main"].stringValue
        description = json["description"].stringValue
    }
}

extension Weathers: Equatable {
    static func == (lhs: Weathers, rhs: Weathers) -> Bool {
        return lhs.id == rhs.id &&
        lhs.main == rhs.main &&
        lhs.description == rhs.description
    }
}

struct CurrentLocation {
    let lat: Double
    let lon: Double
    let timezone: String
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let weathers: [Weathers]
    let category: String
}

extension CurrentLocation {
    init(lat getLat: Double, lon getLon: Double, timezone getTimeZone: String, category getCategory: Exclude, get json: JSON) {
        lat = getLat
        lon = getLon
        timezone = getTimeZone
        pressure = json["pressure"].intValue
        humidity = json["humidity"].intValue
        wind_speed = json["wind_speed"].doubleValue
        
        var listWeather: [Weathers] = []
        
        for selectedWeather in json["weather"].arrayValue {
            listWeather.append(Weathers(get: selectedWeather))
        }
        
        weathers = listWeather
        category = getCategory.rawValue
    }
}

extension CurrentLocation: Equatable {
    static func == (lhs: CurrentLocation, rhs: CurrentLocation) -> Bool {
        return lhs.lat == rhs.lat &&
        lhs.lon == rhs.lon &&
        lhs.timezone == rhs.timezone &&
        lhs.pressure == rhs.pressure &&
        lhs.humidity == rhs.humidity &&
        lhs.wind_speed == rhs.wind_speed &&
        lhs.weathers == rhs.weathers &&
        lhs.category == rhs.category
        
    }
}
