//
//  UserInfo.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import Foundation

struct UserInfo: Codable {
    let name: String
    let pass: String
    let isGuest: Bool
}
