//
//  MenuTableViewCell.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/1.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var menuItem: MenuItem? {
        didSet {
            if let item = menuItem {
                self.iconView.image = item.icon
                self.titleLabel.text = item.title
            }
        }
    }
}
