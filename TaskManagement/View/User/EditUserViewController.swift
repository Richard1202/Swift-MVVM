//
//  EditUserViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController, Alertable {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    private var rolePicker = UIPickerView()
    
    private var viewModel: UserViewModel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
                
        // Set value of user
        nameTextField.text = user.name
        emailTextField.text = user.email
        roleTextField.text = user.role
        
        // Role Picker
        let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.dismissKeyboard))
        roleTextField.inputAccessoryView = toolBar
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        roleTextField.inputView = rolePicker
        
        if let index = Role.allCases.firstIndex(where: { if case AuthManager.shared.userInfo?.role = $0.rawValue { return true }; return false }) {
            rolePicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func updateTapped(_ sender: Any) {
        // Regiser action
        // Validate and call register api
        guard let name = self.nameTextField.text else {
            showAlert(message: "The name field is required")
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
            showAlert(message: "The total hours field is required")
            return
        }
        
        self.viewModel.update(id: user.id, email: email, name: name, password: password, role: role)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

// MARK: - UIPicker Delegate And Datasource Methods

extension EditUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

// MARK: - UITextField Deleage

extension EditUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - ViewModel

extension EditUserViewController {
    private func bind() {
        viewModel = UserViewModel()
        
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
            // Hide Indicator
            navigationController?.popViewController(animated: true)
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
