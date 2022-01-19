//
//  CourseChatCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.01.2022.
//

import UIKit

class CourseChatCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CourseChatCollectionViewCell"
    
    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        return imageView
    }()
    
    let senderNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.primary)()
        label.text = "Me"
        label.textAlignment = .left
        return label
    }()
    
    let chatNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.primary)()
        label.text = "Important"
        label.textAlignment = .left
        return label
    }()
    
    
    let messageContentLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.text = "Я в своем познании настолько"
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    let messageTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.text = "17m"
        return label
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = String(Int.random(in: 0...999))
        label.font = .customFont.style(.caption)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.textAlignment = .center
        return label
    }()
    
    let notificationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    let volumeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "volumeCS"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textAndIcons.style(.tretiary)()
        return imageView
    }()
    
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let titleSV = UIStackView(arrangedSubviews: [chatNameLabel,volumeImageView])
        titleSV.alignment = .fill
        titleSV.distribution = .fill
        titleSV.spacing = 8
        
        let messageSV = UIStackView(arrangedSubviews: [messageContentLabel, messageTimeLabel])
        
        messageSV.alignment = .fill
        messageSV.distribution = .fill
        messageSV.spacing = 8
        
        let textSV = UIStackView(arrangedSubviews: [titleSV, senderNameLabel, messageSV])
        
        textSV.alignment = .leading
        textSV.distribution = .fill
        textSV.spacing = 4
        textSV.axis = .vertical
        
        textSV.translatesAutoresizingMaskIntoConstraints = false
        
        notificationView.addSubview(notificationLabel)
        
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let notificationLabelConstrains = [
            notificationLabel.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 8),
            notificationLabel.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: -8),
            notificationLabel.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 4),
            notificationLabel.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: -4)
            
        ]
        
        NSLayoutConstraint.activate(notificationLabelConstrains)
        
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        rightView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        rightView.addSubview(notificationView)
        
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        let notificationConstrains = [
            notificationView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
            notificationView.centerYAnchor.constraint(equalTo: rightView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(notificationConstrains)
        
        chatImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.addArrangedSubview(chatImageView)
        mainStackView.addArrangedSubview(textSV)
        mainStackView.addArrangedSubview(rightView)
        
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
    }
    
    
}
