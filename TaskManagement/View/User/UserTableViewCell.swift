//
//  UserTableViewCell.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/2.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var userItem: User? {
        didSet {
            if let user = userItem {
                nameLabel.text = user.name
                roleLabel.text = user.role
            }
        }
    }

}
