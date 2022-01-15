//
//  DeadlineTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DeadlineTableViewCell"

    @IBOutlet weak var deadlineTimeView: UIView!
    @IBOutlet weak var submittedTimeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deadlineTimeView.layer.cornerRadius = 4
        submittedTimeView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
