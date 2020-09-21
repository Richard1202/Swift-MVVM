//
//  UserViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit
import SideMenu

class UserViewController: UIViewController, Alertable {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: UserViewModel!
    private var users: [User] = [User]()
    
    private var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.load()
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    func editUser(index: Int) {
        selectedIndex = index
        self.performSegue(withIdentifier: "showUserEdit", sender: self)
    }
    
    func viewUser(index: Int) {
        selectedIndex = index
        self.performSegue(withIdentifier: "showUserView", sender: self)
    }
    
    func deleteUser(index: Int) {
        let task: User = users[index]
        self.viewModel.delete(id: task.id)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showUserEdit" {
            if let destinationVC = segue.destination as? EditUserViewController {
                destinationVC.user = users[selectedIndex]
            }
        }
        if segue.identifier == "showUserView" {
            if let destinationVC = segue.destination as? ViewUserViewController {
                destinationVC.user = users[selectedIndex]
            }
        }
    }

    // MARK: - Menu, Add

    @IBAction func menuTapped(_ sender: Any) {
        // Show the menu
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showUserAdd", sender: self)
    }
}

// MARK: - UITableView Delegate And Datasource Methods

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath as IndexPath) as? UserTableViewCell else {
            fatalError("UserTableViewCell cell is not found")
        }
        
        cell.userItem = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let viewAction = UIContextualAction(style: .destructive, title: "View") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.viewUser(index: indexPath.row)
        }
        viewAction.backgroundColor = UIColor.systemGreen
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.editUser(index: indexPath.row)
        }
        editAction.backgroundColor = UIColor.systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.deleteUser(index: indexPath.row)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction, viewAction ])

        return swipeActions
    }
}

// MARK: - ViewModel

extension UserViewController {
    private func bind() {
        viewModel = UserViewModel()
        
        viewModel.users.observe(on: self) { [weak self] in self?.updateUser($0) }
        viewModel.state.observe(on: self) { [weak self] in self?.updateState($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.updateError($0) }
    }
    
    private func updateUser(_ users: [User]) {
        self.users = users
        self.tableView.reloadData()
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
