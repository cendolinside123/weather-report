//
//  Constants.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation
import UIKit

struct Constants {
    static let _APIkey: String = "149ef91ae7a3f97aaa51d4befc4a4f5d"
    static let url: String = "https://api.openweathermap.org/data/2.5/onecall"
    
    struct userDefaults {
        static let userSession: String = "UserSession"
        static let firstStart: String = "firstStart"
    }
}
enum Exclude: String {
    case current = "current"
    case hourly = "hourly"
    case minutely = "minutely"
    case daily = "daily"
}

enum ListMenu: String {
    case logout = "logout"
    case deleteacount = "Delete Account"
}

enum AuthPage: String {
    case login = "Login"
    case register = "Register"
}

struct ListColor {
    static let biruLumut: UIColor = UIColor(red: 30/255, green: 161/255, blue: 161/255, alpha: 1)
    static let abuTanggung: UIColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    static let transparant: UIColor = UIColor(white: 1, alpha: 0.1)
}
