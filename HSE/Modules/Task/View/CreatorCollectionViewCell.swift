//
//  CreatorCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

final class CreatorCollectionViewCell: UICollectionViewCell {
    static let reusdeIdentifier = "CreatorCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        label.text = "POSTED BY"
        
        return label
    }()
    
    private let creatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        return imageView
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.primary)()
        label.textAlignment = .left
        
        return label
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
        let ownerSV = UIStackView(arrangedSubviews: [creatorImageView, creatorNameLabel])
        ownerSV.distribution = .fill
        ownerSV.alignment = .center
        ownerSV.axis = .horizontal
        ownerSV.spacing = 8
        
        let mainSV = UIStackView(arrangedSubviews: [titleLabel, ownerSV])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .vertical
        mainSV.spacing = 8
        
        contentView.addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainSV.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainSV.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainSV.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32)
        ])
    }
    
    public func configure() {
        creatorNameLabel.text = "Oleg Melnikov"
    }
}
