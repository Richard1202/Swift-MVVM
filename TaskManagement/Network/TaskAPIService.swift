//
//  TaskAPIService.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/31.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class TaskAPIService: NSObject, Requestable {

    static let instance = TaskAPIService()
    
    func load(userId: Int?, startDate: String, endDate: String, callback: @escaping Handler) {
        
        let params = [
            "user_id": userId ?? "",
            "start_date": startDate,
            "end_date": endDate
        ] as [String : Any]
        
        request(method: .get, url: APIEndpoint.taskURL, params: params) { (result) in
           callback(result)
        }
    }
    
    func add(userId: Int, title: String, description: String, date: String, hours: Int, callback: @escaping Handler) {
        
        let params = [
            "user_id": userId,
            "title": title,
            "description": description,
            "date": date,
            "hours": hours
        ] as [String : Any]
        
        request(method: .post, url: APIEndpoint.taskURL, params: params) { (result) in
           callback(result)
        }
    }
    
    func update(id: Int, userId: Int, title: String, description: String, date: String, hours: Int, callback: @escaping Handler) {
        
        let params = [
            "user_id": userId,
            "title": title,
            "description": description,
            "date": date,
            "hours": hours
        ] as [String : Any]
        
        request(method: .put, url: APIEndpoint.taskURL + "/" + String(id), params: params) { (result) in
           callback(result)
        }
    }
    
    func delete(id: Int, callback: @escaping Handler) {
        request(method: .delete, url: APIEndpoint.taskURL + "/" + String(id), params: nil) { (result) in
           callback(result)
        }
    }
}
