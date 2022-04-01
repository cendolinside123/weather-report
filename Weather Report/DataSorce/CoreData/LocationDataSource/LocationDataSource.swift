//
//  LocationDataSource.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import CoreData

struct LocationDataSource {
    private let cdStack: CoreDataStack
    
    init(cdStack: CoreDataStack) {
        self.cdStack = cdStack
    }
}

extension LocationDataSource: LocationDataProvider {
    
    func addLocation(user getUser: UserInfo, location getLocation: CurrentLocation, completion: @escaping (NetworkResult<CurrentLocation>) -> Void ) {
        
        self.cdStack.doInBackground(managedContext: { context in
            let predicateUserName: NSPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\User.username)._kvcKeyPathString!)
            
            let fetchUser: NSFetchRequest<User> = User.fetchRequest()
            fetchUser.predicate = predicateUserName
            
            context.performAndWait({
                do {
                    if let getUser = try context.fetch(fetchUser).first, let mutableUser = getUser.user?.mutableCopy() as? NSMutableSet {
                        
                        let inputLocation = Location(context: context)
                        inputLocation.dt = ProcessInfo().globallyUniqueString
                        inputLocation.lon = getLocation.lon
                        inputLocation.lat = getLocation.lat
                        inputLocation.timezone = getLocation.timezone
                        inputLocation.category = getLocation.category
                        inputLocation.wind_speed = getLocation.wind_speed
                        inputLocation.humidity = Int64(getLocation.humidity)
                        inputLocation.pressure = Int64(getLocation.pressure)
                        inputLocation.item = getUser
                        mutableUser.add(inputLocation)
                        
                        if let getWeather = inputLocation.weather, let getMutableWeather = getWeather.mutableCopy() as? NSMutableSet {
                            
                            for selectedWeather in getLocation.weathers {
                                let weather = Weather(context: context)
                                weather.main = selectedWeather.main
                                weather.id = Int64(selectedWeather.id)
                                weather.desc = selectedWeather.description
                                weather.parentInfo = inputLocation
                                getMutableWeather.add(weather)
                            }
                        }
                        
                        
                        try context.save()
                        completion(.success(getLocation))
                        
                    } else {
                        throw userResponse.unknow
                    }
                } catch let error as NSError {
                    print("LocationDataProvider.addLocation(user:location:completion:) error: \(error.localizedDescription)")
                    completion(.failed(error))
                }
            })
        })
    }
    
    func addLocation(user getUser: UserInfo, location getLocation: [CurrentLocation], completion: @escaping () -> Void ) {
        
        let disaptchGroup = DispatchGroup()
        self.cdStack.doInBackground(managedContext: { context in
            let predicateUserName: NSPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\User.username)._kvcKeyPathString!)
            
            let fetchUser: NSFetchRequest<User> = User.fetchRequest()
            fetchUser.predicate = predicateUserName
            
            do {
                if let getUser = try context.fetch(fetchUser).first, let mutableUser = getUser.user?.mutableCopy() as? NSMutableSet {
                    for itemLocationon in getLocation {
                        disaptchGroup.enter()
                        let inputLocation = Location(context: context)
                        inputLocation.dt = ProcessInfo().globallyUniqueString
                        inputLocation.lon = itemLocationon.lon
                        inputLocation.lat = itemLocationon.lat
                        inputLocation.timezone = itemLocationon.timezone
                        inputLocation.category = itemLocationon.category
                        inputLocation.wind_speed = itemLocationon.wind_speed
                        inputLocation.humidity = Int64(itemLocationon.humidity)
                        inputLocation.pressure = Int64(itemLocationon.pressure)
                        inputLocation.item = getUser
                        
                        mutableUser.add(inputLocation)
                        
                        if let getWeather = inputLocation.weather, let getMutableWeather = getWeather.mutableCopy() as? NSMutableSet {
                            
                            for selectedWeather in itemLocationon.weathers {
                                let weather = Weather(context: context)
                                weather.main = selectedWeather.main
                                weather.id = Int64(selectedWeather.id)
                                weather.desc = selectedWeather.description
                                weather.parentInfo = inputLocation
                                getMutableWeather.add(weather)
                            }
                        }
                        
                        
                        try context.save()
                        disaptchGroup.leave()
                    }
                } else {
                }
            } catch let error as NSError {
                print("LocationDataProvider.addLocation(user:location:completion:) error: \(error.localizedDescription)")
                disaptchGroup.leave()
            }
            disaptchGroup.notify(queue: .main, execute: {
                completion()
            })
            
        })
        
    }
    
    func getLocation(user getUser: UserInfo, exclude getCategory: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            let fetchLocation: NSFetchRequest<Location> = Location.fetchRequest()
            
            let userPredicate = NSPredicate(format: "%K == '\(getUser.name)'", (\Location.item?.username)._kvcKeyPathString!)
            if getCategory.count > 0 {
                var listPredicate: [NSPredicate] = []
                
                listPredicate.append(userPredicate)
                for exluded in getCategory {
                    listPredicate.append(NSPredicate(format: "%K != '\(exluded)'", (\Location.category)._kvcKeyPathString!))
                }
                let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: listPredicate)
                fetchLocation.predicate = andPredicate
            } else {
                fetchLocation.predicate = userPredicate
            }
            
            do {
                let getListLocation = try context.fetch(fetchLocation)
                
                var listDataLocation: [CurrentLocation] = []
                
                for getData in getListLocation {
                    
                    var listWeather: [Weathers] = []
                    if let getListWeather = (getData.weather?.allObjects as? [Weather]) {
                        for getWeather in getListWeather {
                            listWeather.append(Weathers(id: Int(getWeather.id), main: getWeather.main, description: getWeather.desc))
                        }
                    }
                    
                    
                    listDataLocation.append(CurrentLocation(lat: getData.lat, lon: getData.lon, timezone: getData.timezone, pressure: Int(getData.pressure), humidity: Int(getData.humidity), wind_speed: getData.wind_speed, weathers: listWeather, category: getData.category))
                }
                completion(.success(listDataLocation))
                
            } catch let error as NSError {
                completion(.failed(error))
            }
        })
    }
    
    func getLocation(user getUser: User, exclude getCategory: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void) {
        self.cdStack.doInBackground(managedContext: { context in
            let fetchLocation: NSFetchRequest<Location> = Location.fetchRequest()
            
            let userPredicate = NSPredicate(format: "%K == '\(getUser.username)'", (\Location.item?.username)._kvcKeyPathString!)
            if getCategory.count > 0 {
                var listPredicate: [NSPredicate] = []
                
                listPredicate.append(userPredicate)
                for exluded in getCategory {
                    listPredicate.append(NSPredicate(format: "%K != '\(exluded)'", (\Location.category)._kvcKeyPathString!))
                }
                let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: listPredicate)
                fetchLocation.predicate = andPredicate
            } else {
                fetchLocation.predicate = userPredicate
            }
            
            do {
                let getListLocation = try context.fetch(fetchLocation)
                
                var listDataLocation: [CurrentLocation] = []
                
                for getData in getListLocation {
                    
                    var listWeather: [Weathers] = []
                    if let getListWeather = (getData.weather?.allObjects as? [Weather]) {
                        for getWeather in getListWeather {
                            listWeather.append(Weathers(id: Int(getWeather.id), main: getWeather.main, description: getWeather.desc))
                        }
                    }
                    
                    
                    listDataLocation.append(CurrentLocation(lat: getData.lat, lon: getData.lon, timezone: getData.timezone, pressure: Int(getData.pressure), humidity: Int(getData.humidity), wind_speed: getData.wind_speed, weathers: listWeather, category: getData.category))
                }
                completion(.success(listDataLocation))
                
            } catch let error as NSError {
                completion(.failed(error))
            }
        })
    }
    
    
}
