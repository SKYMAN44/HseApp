//
//  DeadlineTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 19.01.2022.
//

import UIKit

final class DeadlineTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DeadlineTableViewCell"
    static let shimmerReuseIdentifier = "ShimmerDeadlineTableViewCell"
    
    private var isShimmerMode: Bool = false
    
    private let deadlineTimeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
//        view.backgroundColor = .primary.style(.filler)()
        view.backgroundColor = .special.style(.warningFiller)()
        view.backgroundColor = .background.style(.accent)()
        
        
        return view
    }()
    
    private let deadlineTimeLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .primary.style(.primary)()
//        label.textColor = .special.style(.warning)()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.caption)()
        label.textAlignment = .center
        
        return label
    }()
    
    private let submittedTimeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    private let submittedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.caption)()
        label.textAlignment = .center
        
        return label
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary.style(.primary)()
        label.font = .customFont.style(.caption)()
        
        return label
    }()
    
    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let separateView: UIView = {
        let view = UIView()
//        view.backgroundColor = .primary.style(.primary)()
//        view.backgroundColor = .special.style(.warning)()
        view.backgroundColor = .outline.style(.heavy)()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        return view
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
    
    // MARK: - setupUI
    private func setupView() {
        self.backgroundColor = .background.style(.firstLevel)()
        
        deadlineTimeView.addSubview(deadlineTimeLabel)
        
        deadlineTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deadlineTimeLabel.topAnchor.constraint(equalTo: deadlineTimeView.topAnchor, constant: 4),
            deadlineTimeLabel.trailingAnchor.constraint(equalTo: deadlineTimeView.trailingAnchor, constant: -8),
            deadlineTimeLabel.bottomAnchor.constraint(equalTo: deadlineTimeView.bottomAnchor, constant: -4),
            deadlineTimeLabel.leadingAnchor.constraint(equalTo: deadlineTimeView.leadingAnchor, constant: 8)
        ])
        
        
        submittedTimeView.addSubview(submittedTimeLabel)
        
        submittedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            submittedTimeLabel.topAnchor.constraint(equalTo: submittedTimeView.topAnchor, constant: 4),
            submittedTimeLabel.trailingAnchor.constraint(equalTo: submittedTimeView.trailingAnchor, constant: -8),
            submittedTimeLabel.bottomAnchor.constraint(equalTo: submittedTimeView.bottomAnchor, constant: -4),
            submittedTimeLabel.leadingAnchor.constraint(equalTo: submittedTimeView.leadingAnchor, constant: 8)
        ])
        
        
        
        let submissionSV = UIStackView(arrangedSubviews: [deadlineTimeView, submittedTimeView])
        
        submissionSV.alignment = .fill
        submissionSV.distribution = .fill
        submissionSV.spacing = 8
        submissionSV.axis = .horizontal
        
        
        let taskSV = UIStackView(arrangedSubviews: [ subjectLabel, taskNameLabel, submissionSV])
        
        taskSV.alignment = .leading
        taskSV.distribution = .fill
        taskSV.spacing = 8
        taskSV.axis = .vertical
        
        
        let mainSV = UIStackView(arrangedSubviews: [separateView, taskSV])
        
        mainSV.alignment = .fill
        mainSV.distribution = .fill
        mainSV.spacing = 12
        mainSV.axis = .horizontal
        
        contentView.addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - External Calls
    public func configure(deadline: Deadline) {
        subjectLabel.text = deadline.courseName
        taskNameLabel.text = deadline.assignmentName
        deadlineTimeLabel.text = deadline.deadlineTime
        if let time = deadline.submissionTime {
            submittedTimeLabel.text = time
        } else {
            submittedTimeLabel.text = "00:00"
        }
    }
    
    public func configureShimmer() {
        subjectLabel.text = "                     "
        taskNameLabel.text = "                         "
        deadlineTimeLabel.text = "           "
        submittedTimeLabel.text = "           "
        isShimmerMode = true
    }

}

// MARK: - Shimmering
extension DeadlineTableViewCell: ShimmeringObject {
    func startShimmer() {
        applyShimmerTo(to: [subjectLabel,
                           taskNameLabel,
                           deadlineTimeView,
                           submittedTimeView])
    }
    
    func stopShimmer() {
        removeShimmerFrom(from: [subjectLabel,
                                 taskNameLabel,
                                 deadlineTimeView,
                                 submittedTimeView])
    }
}
