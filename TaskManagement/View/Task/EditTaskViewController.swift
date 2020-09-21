//
//  EditTaskViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/1.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController, Alertable {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var totalHoursTextField: UITextField!
    
    private var datePicker = UIDatePicker()
    
    private var viewModel: TaskViewModel!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set value of task
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        dateTextField.text = task.date
        totalHoursTextField.text = String(task.hours)
        
        // Date Picker
        let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.dismissKeyboard))
        dateTextField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        datePicker.date = dateFormatter.date(from: task.date) ?? Date()
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
        // Validate if email and password is not empty
        // Call register api
        guard let title = self.titleTextField.text else {
            showAlert(message: "The title field is required")
            return
        }
        
        guard let description = self.descriptionTextView.text else {
            showAlert(message: "The description field is required")
            return
        }
        
        guard let date = self.dateTextField.text else {
            showAlert(message: "The date field is required")
            return
        }
        
        guard let hours = Int(self.totalHoursTextField.text ?? "") else {
            showAlert(message: "The total hours field is required")
            return
        }
        
        self.viewModel.update(id: task.id, userId: task.userId, title: title, description: description, date: date, hours: hours)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: UIDatePicker
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        // Date format -> UITextField
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
}

// MARK: - UITextField Deleage

extension EditTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - ViewModel Delegate

extension EditTaskViewController {
    private func bind() {
        viewModel = TaskViewModel()
        
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
