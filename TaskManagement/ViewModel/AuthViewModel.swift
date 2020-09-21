//
//  UserViewModel.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/27.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthViewModel: BaseViewModel {

    func login(email: String, password: String) {
        // State -> Waiting
        self.handleWaiting()
        
        // Call API
        AuthAPIService.instance.login(email: email, password: password, callback: { result in
            switch result {
            case .success(let data):
                let result = JSON(data)
                
                let token: String = result["token"].stringValue
                
                guard let user = try? JSONDecoder().decode(User.self, from: result["user"].rawData()) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                
                AuthManager.shared.login(token: token, userInfo: user)
                
                // Save Email/Password in User Default
                AuthManager.shared.saveCredential(email: email, password: password)
                
                self.handleSuccess()
                
                break
            case .failure(let error):
                self.handleError(error: error)
            }
        })
    }
    
    func register(email: String, name: String, password: String, role: String) {
        // State -> Waiting
        self.handleWaiting()
        
        AuthAPIService.instance.register(email: email, name: name, password: password, role: role, callback: { result in
            
            switch result {
            case .success(let data):
                let result = JSON(data)
                
                let token: String = result["token"].stringValue
                
                guard let user = try? JSONDecoder().decode(User.self, from: result["user"].rawData()) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }
                
                AuthManager.shared.login(token: token, userInfo: user)
                
                // Save Email/Password in User Default
                AuthManager.shared.saveCredential(email: email, password: password)
                
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
            }
        })
    }
    
}
