//
//  TaskViewModel.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/31.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class TaskViewModel: BaseViewModel {

    var startDate: String = ""
    var endDate: String = ""
    
    var tasks: Observable<[Task]> = Observable([])
    
    func load() {
        // State -> Waiting
        self.handleWaiting()
        
        var userId: Int? = AuthManager.shared.userInfo?.id        
        // If admin user, show all task
        if AuthManager.shared.userInfo?.role == Role.admin.rawValue {
            userId = nil
        }
        
        TaskAPIService.instance.load(userId: userId, startDate: startDate, endDate: endDate, callback: { result in
            switch result {
            case .success(let data):
                guard let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                self.handleSuccess()
                self.tasks.value = tasks
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func add(title: String, description: String, date: String, hours: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        guard let userId = AuthManager.shared.userInfo?.id else {
            self.handleError(error: "No User Id")
            return
        }
        
        TaskAPIService.instance.add(userId: userId ,title: title, description: description, date: date, hours: hours, callback: { result in
            
            switch result {
            case .success( _):
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func update(id: Int, userId: Int, title: String, description: String, date: String, hours: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        TaskAPIService.instance.update(id: id, userId: userId ,title: title, description: description, date: date, hours: hours, callback: { result in
            
            switch result {
            case .success( _):
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func delete(id: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        TaskAPIService.instance.delete(id: id, callback: { result in
            switch result {
            case .success( _):
                self.load()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
}
