//
//  ChatDetailHeaderTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 25.05.2022.
//

import UIKit

final class ChatDetailHeaderTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatDetailHeaderTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
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
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        return imageView
    }()
    private let nameLabel = UILabel()
    private let detailedLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [userImageView, nameLabel, detailedLabel])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 12
        
        addSubview(stackView)
        stackView.pin(to: self, [.bottom: 12, .top: 12, .left: 16, .right: 16])
    }
    
    // MARK: - Configure
    public func configure(chatName: String, _ participantsNumber: Int) {
        self.nameLabel.text = chatName
        self.detailedLabel.text = "\(participantsNumber) participants"
    }
}
