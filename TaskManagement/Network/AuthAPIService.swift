//
//  AuthAPIService.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/28.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class AuthAPIService: NSObject, Requestable {

    static let instance = AuthAPIService()
    
    func login(email: String, password:String, callback: @escaping Handler) {
        let params = ["email": email,
                      "password": password]
     
        authRequest(url: APIEndpoint.loginURL, params: params) { (result) in
           callback(result)
        }
    }
    
    func register(email: String, name: String, password: String, role: String, callback: @escaping Handler) {
        let params = [
            "email": email,
            "name": name,
            "password": password,
            "role" : role
        ]
     
        authRequest(url: APIEndpoint.registerURL, params: params) { (result) in
           callback(result)
        }
    }    
}
