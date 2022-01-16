//
//  ScheduleTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ScheduleTableViewCell"
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(schedule: Schedule) {
        subjectNameLabel.text = schedule.subjectName
    }
    
}
