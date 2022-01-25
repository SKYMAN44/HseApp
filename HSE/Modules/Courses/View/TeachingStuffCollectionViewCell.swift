//
//  TeachingStuffCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.01.2022.
//

import UIKit

final class TeachingStuffCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TeachingStuffCollectionViewCell"
    
    private let imageView: UIImageView = {
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.primary)()
        label.textAlignment = .left
        
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.caption)()
        label.textColor = .primary.style(.primary)()
        label.textAlignment = .left
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let textSV = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        textSV.distribution = .fill
        textSV.alignment = .leading
        textSV.axis = .vertical
        
        
        let mainSV = UIStackView(arrangedSubviews: [imageView, textSV])
        mainSV.distribution = .fill
        mainSV.alignment = .center
        mainSV.axis = .horizontal
        mainSV.spacing = 8
        
        
        
        addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            mainSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
    }
    
    
    public func configure() {
        nameLabel.text = "Nikita Medved"
        roleLabel.text = "Seminarist 193"
    }
    
}
