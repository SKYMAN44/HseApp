//
//  AccountHeaderCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.05.2022.
//

import UIKit
import HSESKIT

final class AccountHeaderCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AccountHeaderCollectionViewCell"
    static let shimmerReuseIdentifier = "ShimmerDeadlineTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        // TODO: - Move circle imageView to spm package + add image fetching(caching) when backend ready
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        return imageView
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.special.style()
        label.textColor = .primary.style(.primary)()
        
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.body.style()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.footnote.style()
        label.textColor = .textAndIcons.style(.secondary)()
        
        return label
    }()
    private let emailView = IconTextInfoView()
    private let addressView = IconTextInfoView()
    private let emailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Email", for: .normal)
        button.backgroundColor = .primary.style(.primary)()
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.setWidth(to: ScreenSize.Width - 32)
        
        return button
    }()
    private var isShimmerMode: Bool = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        emailButton.addTarget(self, action: #selector(emailButtonPressed), for: .touchUpInside)
        
        let topView = UIStackView(arrangedSubviews: [userImageView, typeLabel, nameLabel, groupLabel])
        topView.distribution = .fill
        topView.alignment = .center
        topView.axis = .vertical
        topView.spacing = 8
        
        emailView.setHeight(to: 48)
        addressView.setHeight(to: 48)
        emailView.setWidth(to: ScreenSize.Width - 3)
        addressView.setWidth(to: ScreenSize.Width - 32)
        let infoStackView = UIStackView(arrangedSubviews: [emailView, addressView])
        infoStackView.distribution = .fill
        infoStackView.alignment = .fill
        infoStackView.axis = .vertical
        infoStackView.spacing = 0
        
        let mainSV = UIStackView(arrangedSubviews: [topView, emailButton, infoStackView])
        mainSV.distribution = .fill
        mainSV.alignment = .center
        mainSV.axis = .vertical
        mainSV.spacing = 20
        
        contentView.addSubview(mainSV)
        mainSV.pin(to: contentView)
    }
    
    // MARK: - Configure
    public func configure(_ userInfo: UserApiResponse, _ emailButtonVisible: Bool) {
        typeLabel.text = userInfo.currentRole.rawValue
        nameLabel.text = userInfo.name
        groupLabel.text = userInfo.groupId
        emailButton.isHidden = !emailButtonVisible
        emailView.configure(icon: UIImage(named: "EmailIcon"), text: userInfo.email)
        addressView.configure(icon: UIImage(named: "AddressIcon"), text: userInfo.faculty)
    }
    
    @objc
    private func emailButtonPressed() {}
}
