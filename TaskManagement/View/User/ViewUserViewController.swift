//
//  ViewUserViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController, Alertable {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.text = user.name
        emailTextField.text = user.email
        roleTextField.text = user.role
        
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
