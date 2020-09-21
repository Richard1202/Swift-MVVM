//
//  RegisterViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/30.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, Alertable {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    private var rolePicker = UIPickerView()
    
    private var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind View Model
        bind()
        
        // Dismiss keyboard when tap view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Role Picker
        let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.dismissKeyboard))
        roleTextField.inputAccessoryView = toolBar
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        roleTextField.inputView = rolePicker
    }

    @IBAction func loginTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        // Regiser action
        // Validate if email and password is not empty
        // Call register api
        guard let firstName = self.firstNameTextField.text else {
            showAlert(message: "The first name field is required")
            return
        }
        guard let lastName = self.lastNameTextField.text else {
            showAlert(message: "The last name field is required")
            return
        }
        guard let email = self.emailTextField.text else {
            showAlert(message: "The email field is required")
            return
        }
        guard let password = self.passwordTextField.text else {
            showAlert(message: "The password field is required")
            return
        }
        guard let role = self.roleTextField.text else {
            showAlert(message: "The role field is required")
            return
        }
        let name = firstName + " " + lastName
        
        ProgressHUD.instance.show(parentView: self.view)
        
        self.viewModel.register(email: email, name: name, password: password, role: role)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

// MARK: - UITextField Delegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - UIPicker Delegate And Datasource Methods

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Role.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Role.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        roleTextField.text = Role.allCases[row].rawValue
    }
}

// MARK: - ViewModel

extension RegisterViewController {
    private func bind() {
        viewModel = AuthViewModel()
        
        viewModel.state.observe(on: self) { [weak self] in self?.updateState($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.updateError($0) }
    }
    
    private func updateState(_ state: ActionState?) {
        // Hide Indicator
        ProgressHUD.instance.dismiss()
        
        switch state {
        case .waiting:
            ProgressHUD.instance.show(parentView: self.view)
            break
        case .success:
            // Check User Role
            guard let role = AuthManager.shared.userInfo?.role else {
                showAlert(message: "No role of this user")
                return
            }
            
            if role == Role.admin.rawValue || role == Role.user.rawValue {
                // Admin/User can add/edit/list/view task
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchToTask()
            } else {
                // Manager can add/edit/list/view use
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchToUser()
            }
            break
        case .fail:
            break
        default:
            break
        }
    }
    
    private func updateError(_ message: String) {
        guard !message.isEmpty else { return }
        self.showError(message: message)
    }
}
