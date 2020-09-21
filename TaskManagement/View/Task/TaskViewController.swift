//
//  TaskViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/30.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit
import SideMenu

class TaskViewController: UIViewController, Alertable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
        
    private var viewModel: TaskViewModel!
    private var tasks: [Task] = [Task]()
    
    private var startDatePicker = UIDatePicker()
    private var endDatePicker = UIDatePicker()
    
    
    private var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        // Refresh UI
        // Called when view appear/filter condition change
        viewModel.startDate = startDateField.text ?? ""
        viewModel.endDate = endDateField.text ?? ""
        
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
    
    func setupDatePicker() {
        // Setup Toolbar for Datepicker
        let startToolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.doneStartDate), clearSelect: #selector(self.clearStartDate))
        startDateField.inputAccessoryView = startToolBar
        
        let endToolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.doneEndDate), clearSelect: #selector(self.clearEndDate))
        endDateField.inputAccessoryView = endToolBar
        
        // Setup Datepicker
        startDatePicker.datePickerMode = .date
        startDateField.inputView = startDatePicker
        
        endDatePicker.datePickerMode = .date
        endDateField.inputView = endDatePicker
    }
    
    func editTask(index: Int) {
        selectedIndex = index
        self.performSegue(withIdentifier: "showTaskEdit", sender: self)
    }
    
    func viewTask(index: Int) {
        selectedIndex = index
        self.performSegue(withIdentifier: "showTaskView", sender: self)
    }
    
    func deleteTask(index: Int) {
        let task: Task = tasks[index]
        
        viewModel.startDate = startDateField.text ?? ""
        viewModel.endDate = endDateField.text ?? ""
        
        self.viewModel.delete(id: task.id)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTaskEdit" {
            if let destinationVC = segue.destination as? EditTaskViewController {
                destinationVC.task = tasks[selectedIndex]
            }
        }
        if segue.identifier == "showTaskView" {
            if let destinationVC = segue.destination as? ViewTaskViewController {
                destinationVC.task = tasks[selectedIndex]
            }
        }
        if segue.identifier == "showSummary" {
            if let destinationVC = segue.destination as? SummaryViewController {
                
                var summaryList = [Summary]()
                
                for task in tasks {
                    if let index = summaryList.firstIndex(where: { $0.date == task.date }) {
                        var summary:Summary = summaryList[index]
                        summary.hours += task.hours
                        summary.description += "\n" + task.description
                    } else {
                        summaryList.append(Summary(date: task.date, hours: task.hours, description: task.description))
                    }
                }
                destinationVC.summaryList = summaryList
            }
        }
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Menu, Add

    @IBAction func menuTapped(_ sender: Any) {
        // Show the menu
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showTaskAdd", sender: self)
    }
    
    @IBAction func exportTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showSummary", sender: self)
    }
}

// MARK: UIDatePicker

extension TaskViewController {
           
    @objc func doneStartDate() {
        view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: startDatePicker.date)
        
        if startDateField.text != startDate {
           startDateField.text = startDate
           refresh()
        }
    }
    
    @objc func doneEndDate() {
        view.endEditing(true)
        
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       let endDate = dateFormatter.string(from: endDatePicker.date)
       
       if endDateField.text != endDate {
          endDateField.text = endDate
          refresh()
       }
    }

    @objc func clearStartDate() {
        view.endEditing(true)
        
        if startDateField.text != "" {
            startDateField.text = ""
            refresh()
        }
    }
    
    @objc func clearEndDate() {
        view.endEditing(true)
        
        if endDateField.text != "" {
            endDateField.text = ""
            refresh()
        }
    }
}

// MARK: - UITableView Delegate And Datasource Methods

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: TaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath as IndexPath) as? TaskTableViewCell else {
            fatalError("TaskTableViewCell cell is not found")
        }
        
        cell.taskItem = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let viewAction = UIContextualAction(style: .destructive, title: "View") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.viewTask(index: indexPath.row)
        }
        viewAction.backgroundColor = UIColor.systemGreen
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.editTask(index: indexPath.row)
        }
        editAction.backgroundColor = UIColor.systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.deleteTask(index: indexPath.row)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction, viewAction ])

        return swipeActions
    }
}

// MARK: - ViewModel

extension TaskViewController {
    private func bind() {
        viewModel = TaskViewModel()
        
        viewModel.tasks.observe(on: self) { [weak self] in self?.updateTask($0) }
        viewModel.state.observe(on: self) { [weak self] in self?.updateState($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.updateError($0) }
    }
    
    private func updateTask(_ tasks: [Task]) {
        self.tasks = tasks
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
