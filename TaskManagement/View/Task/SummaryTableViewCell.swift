//
//  SummaryTableViewCell.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/9/4.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: Summary? {
        didSet {
            if let summary = data {
                dateLabel.text = summary.date
                hoursLabel.text = String(summary.hours) + "h"
                descriptionView.text = summary.description
            }
        }
   }

}
