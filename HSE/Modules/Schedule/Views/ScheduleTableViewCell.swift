//
//  ScheduleTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 19.01.2022.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ScheduleTableViewCell"
    
    private let separatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.backgroundColor = .outline.style(.heavy)()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        return view
    }()
    
    
    private let subjectNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.primary)()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let eventTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.caption)()
        label.textColor = .primary.style(.primary)()
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.secondary)()
        
        return label
    }()
    
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.caption)()
        label.textColor = .textAndIcons.style(.secondary)()
        
        return label
    }()
    
    private let timeSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return stackView
    }()
    
    private let onlineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .textAndIcons.style(.tretiary)()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
    
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .background.style(.firstLevel)()
        
        
        timeSV.addArrangedSubview(startTimeLabel)
        timeSV.addArrangedSubview(endTimeLabel)
        
        let rigthStackView = UIStackView(arrangedSubviews: [eventTypeLabel, subjectNameLabel, locationLabel, onlineImageView])
        
        rigthStackView.distribution = .fill
        rigthStackView.alignment = .leading
        rigthStackView.axis = .vertical
        rigthStackView.spacing = 4
        
        
        rigthStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let mainSV = UIStackView(arrangedSubviews: [timeSV, separatorView, rigthStackView])
        
        mainSV.alignment = .fill
        mainSV.distribution = .fill
        mainSV.spacing = 12
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainSV)
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        rigthStackView.topAnchor.constraint(equalTo: mainSV.topAnchor, constant: 4).isActive = true
        rigthStackView.bottomAnchor.constraint(equalTo: mainSV.bottomAnchor, constant: -4).isActive = true
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configure(schedule: TimeSlot) {
        subjectNameLabel.text = schedule.subjectName
        eventTypeLabel.text = "SEMINAR"
        startTimeLabel.text = "10:30"
        endTimeLabel.text = "15:00"
        locationLabel.text = "Online"
        onlineImageView.image = UIImage(named: "camera")
    }

}
