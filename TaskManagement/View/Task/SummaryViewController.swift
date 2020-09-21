//
//  SummaryViewController.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/4.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var summaryList: [Summary]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath as IndexPath) as? SummaryTableViewCell else {
            fatalError("SummaryTableViewCell cell is not found")
        }
        
        cell.data = summaryList![indexPath.row]
        return cell
    }
}

