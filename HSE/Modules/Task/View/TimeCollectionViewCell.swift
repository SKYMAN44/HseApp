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
        label.text = "Title"
        
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
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
        
        mainSV.pin(to: self)
        
        dateView.addSubview(dateLabel)
        dateLabel.pin(to: dateView, [.top: 4, .bottom: 4, .left: 8, .right: 8])
        
        timeView.addSubview(timeLabel)
        timeLabel.pin(to: timeView, [.top: 4, .bottom: 4, .left: 8, .right: 8])
    }
    
    // MARK: - External call
    public func configure(title: String) {
        titleLabel.text = title
        dateLabel.text = "27.01.22"
        timeLabel.text = "17:39"
    }
}
