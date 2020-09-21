//
//  BaseViewModel.swift
//  TaskManagement
//
//  Created by Richard Stewart on 2020/9/5.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation

class BaseViewModel {

    let error: Observable<String> = Observable("")
    let state: Observable<ActionState> = Observable(.none)
    
    func handleError(error: String) {
        self.state.value = ActionState.fail
        self.error.value = error
    }
    
    func handleSuccess() {
        self.state.value = ActionState.success
    }
    
    func handleWaiting() {
        self.state.value = ActionState.waiting
    }
}
