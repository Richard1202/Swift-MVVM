//
//  ViewTaskViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/1.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class ViewTaskViewController: UIViewController, Alertable {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var totalHoursTextField: UITextField!
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        dateTextField.text = task.date
        totalHoursTextField.text = String(task.hours)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backTapped(_ sender: Any) {
        // Back Action
        navigationController?.popViewController(animated: true)
    }
}
