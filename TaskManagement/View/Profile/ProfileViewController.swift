//
//  ProfileViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/3.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, Alertable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var preferHourTextField: UITextField!
    
    var activeField:UITextField?
    var keyboardHeight:CGFloat?
    
    private var rolePicker = UIPickerView()
    
    private var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        nameTextField.text = AuthManager.shared.userInfo?.name
        emailTextField.text = AuthManager.shared.userInfo?.email
        roleTextField.text = AuthManager.shared.userInfo?.role
        if let preferWorkHours = AuthManager.shared.userInfo?.preferWorkHours {
            preferHourTextField.text = preferWorkHours > 0 ? String(preferWorkHours) : ""
        }
        
        
        // Role Picker
        let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.dismissKeyboard))
        roleTextField.inputAccessoryView = toolBar
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        roleTextField.inputView = rolePicker
        
        if let index = Role.allCases.firstIndex(where: { if case AuthManager.shared.userInfo?.role = $0.rawValue { return true }; return false }) {
            rolePicker.selectRow(index, inComponent: 0, animated: false)
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        guard let preferWorkHours = Int(self.preferHourTextField.text ?? "0") else {
            showAlert(message: "The prefer work hours field is required")
            return
        }
        
        ProgressHUD.instance.show(parentView: self.view)
        
        guard let userId = AuthManager.shared.userInfo?.id else {
            return
        }
        self.viewModel.update(id: userId, email: email, name: name, password: password, role: role, preferWorkHours: preferWorkHours)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        // Show the menu
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    //MARK: Methods to manage keybaord
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
}

// MARK: - UIPicker Delegate And Datasource Methods

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - ViewModel

extension ProfileViewController {
    private func bind() {
        viewModel = ProfileViewModel()
        
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
        default:
            break
        }
    }
    
    private func updateError(_ message: String) {
        guard !message.isEmpty else { return }
        self.showError(message: message)
    }
}
