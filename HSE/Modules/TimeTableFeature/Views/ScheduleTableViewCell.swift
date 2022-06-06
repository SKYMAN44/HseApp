//
//  ScheduleTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 19.01.2022.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleTableViewCell"
    static let shimmerReuseIdentifier = "ShimmerScheduleTableViewCell"
    
    private var isShimmerMode: Bool = false
    
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
        imageView.addConstraint(
            NSLayoutConstraint(
                item: imageView,
                attribute: .height,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
        )
    
        return imageView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if(isShimmerMode) {
            stopShimmer()
            startShimmer()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isShimmerMode = false
        stopShimmer()
    }
    
    deinit { }
    
    // MARK: - UI setup
    private func setupView() {
        self.backgroundColor = .background.style(.firstLevel)()
        
        timeSV.addArrangedSubview(startTimeLabel)
        timeSV.addArrangedSubview(endTimeLabel)
        
        let rigthStackView = UIStackView(arrangedSubviews: [eventTypeLabel, subjectNameLabel, locationLabel, onlineImageView])
        
        rigthStackView.distribution = .fill
        rigthStackView.alignment = .leading
        rigthStackView.axis = .vertical
        rigthStackView.spacing = 4
        
        let mainSV = UIStackView(arrangedSubviews: [timeSV, separatorView, rigthStackView])
        
        mainSV.alignment = .fill
        mainSV.distribution = .fill
        mainSV.axis = .horizontal
        mainSV.spacing = 12
        
        contentView.addSubview(mainSV)
        
        mainSV.pin(to: contentView, [.top: 8, .bottom: 8, .left: 16, .right: 16])
        rigthStackView.pinTop(to: mainSV.topAnchor, 4)
        rigthStackView.pinBottom(to: mainSV.bottomAnchor, 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - External
    public func configure(schedule: TimeSlot) {
        subjectNameLabel.text = schedule.subjectName
        eventTypeLabel.text = schedule.type
        startTimeLabel.text = schedule.timeStart
        endTimeLabel.text = schedule.timeEnd
//        startTimeLabel.text = schedule.getNormalTimeString(schedule.timeStart)
//        endTimeLabel.text = schedule.getNormalTimeString(schedule.timeEnd)
        locationLabel.text = schedule.visitType ? "Online" : "Offline"
        onlineImageView.image = UIImage(named: "camera")
    }
    
    public func configureShimmer() {
        subjectNameLabel.text = "                     "
        eventTypeLabel.text = "           "
        startTimeLabel.text = "           "
        endTimeLabel.text = "           "
        locationLabel.text = "           "
        isShimmerMode = true
    }

}


// MARK: - Shimmer
extension ScheduleTableViewCell: ShimmeringObject {
    public func startShimmer() {
        applyShimmerTo(
            to: [
            subjectNameLabel,
            eventTypeLabel,
            locationLabel,
            startTimeLabel,
            endTimeLabel,
            onlineImageView
        ])
    }
    
    public func stopShimmer() {
        removeShimmerFrom(
            from: [
                subjectNameLabel,
                eventTypeLabel,
                locationLabel,
                startTimeLabel,
                endTimeLabel,
                onlineImageView
            ]
        )
    }
}
