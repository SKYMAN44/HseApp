//
//  ChatDetailTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 25.05.2022.
//

import UIKit

final class ChatDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatDetailTableViewCell"
    
    public let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        return imageView
    }()
    private let usernameLabel = UILabel()
    
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
        let stackView = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        addSubview(stackView)
        stackView.pin(to: self, [.bottom: 4, .top: 4, .left: 16, .right: 16])
    }
    
    // MARK: - Configure
    public func configure(name: String) {
        self.usernameLabel.text = name
    }
}
