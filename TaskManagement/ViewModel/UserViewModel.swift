//
//  UserViewModel.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class UserViewModel: BaseViewModel {

    var users: Observable<[User]> = Observable([])
    
    func load() {
        // State -> Waiting
        self.handleWaiting()
        
        UserAPIService.instance.load(callback: { result in
            switch result {
            case .success(let data):

                guard let users = try? JSONDecoder().decode([User].self, from: data) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                self.handleSuccess()
                self.users.value = users
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
    
    func add(email: String, name: String, password: String, role: String) {
        // State -> Waiting
        self.handleWaiting()
        
        UserAPIService.instance.add(email: email ,name: name, password: password, role: role, callback: { result in
            
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
    
    func update(id: Int, email: String, name: String, password: String, role: String) {
        // State -> Waiting
        self.handleWaiting()
        
        UserAPIService.instance.update(id: id, email: email ,name: name, password: password, role: role, callback: { result in
            
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
        
        
        UserAPIService.instance.delete(id: id, callback: { result in
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
