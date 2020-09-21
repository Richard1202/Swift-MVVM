//
//  ViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/27.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Alertable {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind View Model
        bind()
        
        // Dismiss keyboard when tap view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let email = AuthManager.shared.getEmail()
        let password = AuthManager.shared.getPassword()
        
        // Auto Login if saved credential
        if !email.isEmpty && !password.isEmpty {
            emailTextField.text = email
            passwordTextField.text = password
            login()
        }
    }

    @IBAction func loginTapped(_ sender: Any) {
        // Called when login button is tapped
        login()
    }
    
    func login() {
        // Login action
        // Validate if email and password is not empty
        // Call login api
        guard let email = self.emailTextField.text else {
            showAlert(message: "The email field is required")
            return
        }
        
        guard let password = self.passwordTextField.text else {
            showAlert(message: "The password field is required")
            return
        }
        
        self.viewModel.login(email: email, password: password)
    }
    
    @objc func dismissKeyboard() {
       //Causes the view (or one of its embedded text fields) to resign the first responder status.
       view.endEditing(true)
   }
}

// MARK: - UITextField Deleage

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - ViewModel

extension LoginViewController {
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
