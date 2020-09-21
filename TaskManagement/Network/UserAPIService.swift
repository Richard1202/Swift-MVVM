//
//  UserAPIService.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class UserAPIService: NSObject, Requestable {

    static let instance = UserAPIService()
    
    func load(callback: @escaping Handler) {
        
        request(method: .get, url: APIEndpoint.userURL, params: nil) { (result) in
           callback(result)
        }
    }
    
    func add(email: String, name: String, password: String, role: String, callback: @escaping Handler) {
        
        let params = [
            "email": email,
            "name": name,
            "password": password,
            "role": role
        ] as [String : Any]
        
        request(method: .post, url: APIEndpoint.userURL, params: params) { (result) in
           callback(result)
        }
    }
    
    func update(id: Int, email: String, name: String, password: String, role: String, callback: @escaping Handler) {
        
        let params = [
            "email": email,
            "name": name,
            "password": password,
            "role": role,
        ] as [String : Any]
        
        request(method: .put, url: APIEndpoint.userURL + "/" + String(id), params: params) { (result) in
           callback(result)
        }
    }
    
    func delete(id: Int, callback: @escaping Handler) {
        request(method: .delete, url: APIEndpoint.userURL + "/" + String(id), params: nil) { (result) in
           callback(result)
        }
    }
}
