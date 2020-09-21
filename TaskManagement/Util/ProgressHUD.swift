//
//  ProgressHUD.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/28.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation
import JGProgressHUD

class ProgressHUD: NSObject {

    static let instance = ProgressHUD()

    var hud: JGProgressHUD?
    
    func show(parentView: UIView) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = "Loading"
        hud?.show(in: parentView)
    }
    
    func dismiss() {
        hud?.dismiss()
        hud = nil        
    }

}
