//
//  MenuViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/1.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var menuItems: [MenuItem] = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = AuthManager.shared.userInfo?.name
        
        // Do any additional setup after loading the view.
        if (AuthManager.shared.userInfo?.role == Role.admin.rawValue || AuthManager.shared.userInfo?.role == Role.user.rawValue) {
            menuItems.append(MenuItem(icon: UIImage(named: "Task"), title: "Task", type: MenuType.task))
        }
        if (AuthManager.shared.userInfo?.role == Role.admin.rawValue || AuthManager.shared.userInfo?.role == Role.manager.rawValue) {
            menuItems.append(MenuItem(icon: UIImage(named: "User"), title: "User", type: MenuType.user))
        }
        menuItems.append(MenuItem(icon: UIImage(named: "Setting"), title: "Profile", type: MenuType.profile))
        menuItems.append(MenuItem(icon: UIImage(named: "Logout"), title: "Log out", type: MenuType.logout))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableView Delegate And Datasource Methods

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath as IndexPath) as? MenuTableViewCell else {
            fatalError("MenuTableViewCell cell is not found")
        }
        
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = menuItems[indexPath.row]
        
        if selectedItem.type == MenuType.task {
            dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToTask()
        }
        if selectedItem.type == MenuType.user {
            dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToUser()
        }
        if selectedItem.type == MenuType.profile {
            dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToProfile()
        }
        if selectedItem.type == MenuType.logout {
            dismiss(animated: true, completion: nil)
            
            // Remove saved user info
            AuthManager.shared.logout()
            AuthManager.shared.removeCredentail()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToLogin()
        }
    }
}
