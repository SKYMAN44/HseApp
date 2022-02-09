//
//  TimeCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

final class TimeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    private let dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    private let timeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        dateView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -4),
            dateLabel.leftAnchor.constraint(equalTo: dateView.leftAnchor, constant: 8),
            dateLabel.rightAnchor.constraint(equalTo: dateView.rightAnchor, constant: -8)
        ])
        
        timeView.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: timeView.topAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: timeView.bottomAnchor, constant: -4),
            timeLabel.leftAnchor.constraint(equalTo: timeView.leftAnchor, constant: 8),
            timeLabel.rightAnchor.constraint(equalTo: timeView.rightAnchor, constant: -8)
        ])
        
        let dateSV = UIStackView(arrangedSubviews: [dateView, timeView])
        
        dateSV.distribution = .fill
        dateSV.alignment = .fill
        dateSV.axis = .horizontal
        dateSV.spacing = 8
        
        let mainSV = UIStackView(arrangedSubviews: [titleLabel, dateSV])
        mainSV.distribution = .fill
        mainSV.alignment = .leading
        mainSV.axis = .vertical
        mainSV.spacing = 8
        
        self.contentView.addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        mainSV.pin(to: contentView)
        contentView.setWidth(to: ScreenSize.Width - 32)
        
    }
    
    public func configure(title: String) {
        titleLabel.text = title
        dateLabel.text = "27.01.22"
        timeLabel.text = "17:39"
        
    }
}
