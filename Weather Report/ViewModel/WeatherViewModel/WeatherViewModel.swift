//
//  WeatherViewModel.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

class WeatherViewModel {
    private var useCase: WeatherUseCase?
    var listData: [CurrentLocation] = []
    var dataResponse: (([CurrentLocation]) -> Void)?
    var errorReponse: ((Error) -> Void)?
    var cacheResponse: (([CurrentLocation]) -> Void)?
    
    init(useCase: WeatherUseCase) {
        self.useCase = useCase
    }
    
}

extension WeatherViewModel: WeatherVMGuideline {
    func getWeather(lat getLat: Double, lon getLon: Double, exclude getExclude: [String], user data: UserInfo, reload time: Int) {
        
        var listWeathers: [CurrentLocation] = []
        var onlineError: Error?
        
        let groupLoadCache = DispatchGroup()
        
        groupLoadCache.enter()
        self.getCacheData(getUser: data, getExclude: getExclude, completion: {
            groupLoadCache.leave()
        })
        groupLoadCache.enter()
        self.useCase?.weatherOnlineRequest.getWeather(lat: getLat, lon: getLon, exclude: getExclude, completion: { result in
            switch result {
            case .success(let data):
                listWeathers = data
                
            case .failed(let error):
                onlineError = error
            }
            groupLoadCache.leave()
        })
        
        groupLoadCache.notify(queue: .global(), execute: { [weak self] in
            
            if listWeathers.count <= 0 || onlineError != nil {
                if time > 0 {
                    self?.getWeather(lat: getLat, lon: getLon, exclude: getExclude, user: data, reload: time - 1)
                    return
                } else {
                    if let getOnlineError = onlineError {
                        self?.errorReponse?(getOnlineError)
                    } else {
                        self?.errorReponse?(ErrorResponse.notFound)
                    }
                    return
                }
            }
            
            self?.saveLocalData(getUser: data, listLocation: listWeathers, completion: {
                self?.getSavedData(getUser: data, getExclude: getExclude)
            })
        })
        
    }
    
    private func getCacheData(getUser: UserInfo, getExclude: [String], completion: @escaping () -> Void) {
        self.useCase?.locationLocalData.getLocation(user: getUser, exclude: getExclude, completion: { [weak self] result in
            switch result {
            case.success(let data):
                self?.listData = data
                self?.cacheResponse?(data)
            case .failed(let error):
                print("getCacheData(getUser:getExclude:completion: error: \(error.localizedDescription)")
            }
            completion()
        })
    }
    
    private func saveLocalData(getUser: UserInfo, listLocation: [CurrentLocation], completion: @escaping () -> Void) {
        
        let newList = listLocation.filter({!self.listData.contains($0)})
        
        if newList.count > 0 {
            self.useCase?.locationLocalData.addLocation(user: getUser, location: newList, completion: {
                completion()
            })
        } else {
            completion()
        }
        
    }
    
    private func getSavedData(getUser: UserInfo, getExclude: [String]) {
        self.useCase?.locationLocalData.getLocation(user: getUser, exclude: getExclude, completion: { [weak self] result in
            switch result {
            case.success(let data):
                self?.listData = data
                self?.dataResponse?(data)
            case .failed(let error):
                print("getCacheData(getUser:getExclude:completion: error: \(error.localizedDescription)")
            }
        })
    }
    
}
