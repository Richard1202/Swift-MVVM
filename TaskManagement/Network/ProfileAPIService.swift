//
//  ProfileAPIService.swift
//  TaskManagement
//
//  Created by Richard Stewart on 2020/9/16.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class ProfileAPIService: NSObject, Requestable {

    static let instance = ProfileAPIService()
    
    func update(email: String, name: String, password: String, role: String, preferWorkHours: Int, callback: @escaping Handler) {
        
        let params = [
            "email": email,
            "name": name,
            "password": password,
            "role": role,
            "prefer_work_hours": preferWorkHours
        ] as [String : Any]
        
        request(method: .put, url: APIEndpoint.profileURL, params: params) { (result) in
           callback(result)
        }
    }
}
