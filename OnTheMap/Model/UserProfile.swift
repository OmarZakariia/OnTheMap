//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 04/10/2021.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}

