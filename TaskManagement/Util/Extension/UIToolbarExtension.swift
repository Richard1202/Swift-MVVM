//
//  UIToolbarExtension.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/1.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

extension UIToolbar {

    func ToolbarPiker(doneSelect: Selector, clearSelect: Selector?) -> UIToolbar {

        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: clearSelect)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: doneSelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([ clearButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }

    func ToolbarPiker(doneSelect: Selector) -> UIToolbar {

        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: doneSelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        return toolBar
    }
}
