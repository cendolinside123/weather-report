//
//  WeathersDataProvider.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import Alamofire
import SwiftyJSON

struct WeathersDataProvider {
    
}

extension WeathersDataProvider: WeatherNetworkProvider {
    func getWeather(lat: Double, lon: Double, exclude: [String], completion: @escaping (NetworkResult<[CurrentLocation]>) -> Void) {
        struct ParamAPI: Encodable {
            let lat: Double
            let lon: Double
            let exclude: [String]
            let appid: String
        }
        
        var listExclude: [String] = [Exclude.minutely.rawValue]
        listExclude += exclude
        
        let param = ParamAPI(lat: lat, lon: lon, exclude: listExclude, appid: Constants._APIkey)
        AF.request(Constants.url, method: .get, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var listWeathers: [CurrentLocation] = []
                let getLat = json["lat"].doubleValue
                let getLon = json["lon"].doubleValue
                let getTimeZone = json["timezone"].stringValue
                
                for getListWeather in json[Exclude.daily.rawValue].arrayValue {
                    listWeathers.append(CurrentLocation(lat: getLat, lon: getLon, timezone: getTimeZone, category: Exclude.daily, get: getListWeather))
                }
                
                for getListWeather in json[Exclude.current.rawValue].arrayValue {
                    listWeathers.append(CurrentLocation(lat: getLat, lon: getLon, timezone: getTimeZone, category: Exclude.current, get: getListWeather))
                }
                
                for getListWeather in json[Exclude.hourly.rawValue].arrayValue {
                    listWeathers.append(CurrentLocation(lat: getLat, lon: getLon, timezone: getTimeZone, category: Exclude.hourly, get: getListWeather))
                }
                completion(.success(listWeathers))
                
            case .failure(let error):
                completion(.failed(error))
            }
        })
        
    }
}
