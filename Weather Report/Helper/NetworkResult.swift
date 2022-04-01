//
//  NetworkResult.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//


import Foundation

enum NetworkResult<T> {
    case success(T)
    case failed(Error)
}

enum ErrorResponse: Error, LocalizedError {
    case loadFailed
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .loadFailed:
            return NSLocalizedString(
                "Failed to read/load data",
                comment: ""
            )
        case .notFound:
            return NSLocalizedString(
                "Data not found",
                comment: ""
            )
        }
    }
}

enum userResponse: Error, LocalizedError {
    case registered
    case unknow
    
    var errorDescription: String? {
        switch self {
        case .registered:
            return NSLocalizedString(
                "User already registered",
                comment: ""
            )
        
        case .unknow:
            return NSLocalizedString(
                "Unknow error",
                comment: ""
            )
        }
    }
}
