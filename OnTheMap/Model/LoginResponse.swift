//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 04/10/2021.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
