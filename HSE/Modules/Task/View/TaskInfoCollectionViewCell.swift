//
//  TaskInfoCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

final class TaskInfoCollectionViewCell: UICollectionViewCell {
    static let reusdeIdentifier = "TaskInfoCollectionViewCell"
    
    private let courseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        label.text = "COURSE"
        
        return label
    }()
    
    private let courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .primary.style(.primary)()
        label.textAlignment = .left
        label.text = "MACHIENE LEARNING"
        
        return label
    }()
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        label.text = "NAME"
        
        return label
    }()
    
    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.title)()
        label.textColor = .textAndIcons.style(.primary)()
        label.textAlignment = .left
        label.text = "HW-14 Venus-Anus"
        
        return label
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        label.text = "DESCRIPTION"
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
       let courseSV = UIStackView(arrangedSubviews: [courseTitleLabel, courseNameLabel])
        courseSV.distribution = .fill
        courseSV.alignment = .fill
        courseSV.axis = .vertical
        courseSV.spacing = 8
        
        let taskSV = UIStackView(arrangedSubviews: [taskTitleLabel, taskNameLabel])
        taskSV.distribution = .fill
        taskSV.alignment = .fill
        taskSV.axis = .vertical
        taskSV.spacing = 8
        
        let descriptionSV = UIStackView(arrangedSubviews: [descriptionTitleLabel, descriptionLabel])
        descriptionSV.distribution = .fill
        descriptionSV.alignment = .fill
        descriptionSV.axis = .vertical
        descriptionSV.spacing = 8
        
        let mainSV = UIStackView(arrangedSubviews: [courseSV, taskSV, descriptionSV])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 20
        
        self.contentView.addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: topAnchor),
            mainSV.leftAnchor.constraint(equalTo: leftAnchor),
            mainSV.rightAnchor.constraint(equalTo: rightAnchor),
            mainSV.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainSV.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32)
        ])
    }

    public func configure() {}
}
