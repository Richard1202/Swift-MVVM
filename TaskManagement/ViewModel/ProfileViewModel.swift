//
//  ProfileViewModel.swift
//  TaskManagement
//
//  Created by Richard Stewart on 2020/9/5.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class ProfileViewModel: BaseViewModel {

    func update(id: Int, email: String, name: String, password: String, role: String, preferWorkHours: Int) {
        // State -> Waiting
        self.handleWaiting()
        
        ProfileAPIService.instance.update(email: email ,name: name, password: password, role: role, preferWorkHours: preferWorkHours, callback: { result in
            
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                    self.handleError(error: "Json Parse Error")
                    return
                }

                // Update userInfo
                AuthManager.shared.userInfo = user
                
                // Update saved credential
                if !email.isEmpty {
                    AuthManager.shared.updateEmail(email: email)
                }
                if !password.isEmpty {
                    AuthManager.shared.updatePassword(password: password)
                }
                
                self.handleSuccess()
                break
            case .failure(let error):
                self.handleError(error: error)
                break
            }
        })
    }
}
