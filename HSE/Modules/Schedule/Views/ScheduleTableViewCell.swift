//
//  ScheduleTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ScheduleTableViewCell"
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .background.style(.firstLevel)()
        
        eventTypeLabel.font = .customFont.style(.caption)()
        eventTypeLabel.textColor = .primary.style(.primary)()
        
        subjectNameLabel.font = .customFont.style(.body)()
        subjectNameLabel.textColor = .textAndIcons.style(.primary)()
        
        locationLabel.font = .customFont.style(.footnote)()
        locationLabel.textColor = .textAndIcons.style(.secondary)()
        
        startTimeLabel.font = .customFont.style(.special)()
        startTimeLabel.textColor = .textAndIcons.style(.primary)()
        
        endTimeLabel.font = .customFont.style(.caption)()
        endTimeLabel.textColor = .textAndIcons.style(.secondary)()
        
        separatorView.tintColor = .background.style(.accent)()
        separatorView.layer.cornerRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(schedule: Schedule) {
        subjectNameLabel.text = schedule.subjectName
    }
    
}
