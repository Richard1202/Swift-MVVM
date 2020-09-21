//
//  TaskTableViewCell.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/31.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var taskItem: Task? {
        didSet {
            if let task = taskItem {
                self.titleLabel.text = task.title
                self.dateLabel.text = task.date
                self.hourLabel.text = String(task.hours) + "h"
                if (task.prefer ?? 0) == 1 {
                    barView.backgroundColor = UIColor.systemRed
                } else {
                    barView.backgroundColor = UIColor.systemGreen
                }
                if AuthManager.shared.userInfo?.role == Role.admin.rawValue {
                    self.userNameLabel.isHidden = false
                    self.userNameLabel.text = task.userName
                } else {
                    self.userNameLabel.isHidden = true
                }
                
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
