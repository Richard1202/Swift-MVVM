//
//  AppConfiguration.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/28.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation


struct APIEndpoint {
    static let apiBaseURL: String = "http://192.168.31.42:8000"
    
    static let loginURL: String = apiBaseURL + "/api/auth/login"
    static let registerURL: String = apiBaseURL + "/api/auth/register"
    static let taskURL: String = apiBaseURL + "/api/tasks"
    static let userURL: String = apiBaseURL + "/api/users"
    static let profileURL: String = apiBaseURL + "/api/profile"
}

enum Role: String, CaseIterable {
    case admin = "Admin"
    case manager = "Manager"
    case user = "User"

    init?(id : Int) {
        switch id {
        case 0: self = .admin
        case 1: self = .manager
        case 2: self = .user
        default: return nil
        }
    }
}

enum MenuType: String {
    case task
    case user
    case profile
    case logout
}

enum ActionState {
    case none
    case success
    case fail
    case waiting
}
