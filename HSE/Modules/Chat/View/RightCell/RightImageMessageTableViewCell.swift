//
//  RightImageMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

final class RightImageMessageTableViewCell: BaseRightMessageTableViewCell, MessageCellProtocol {
    static var reuseIdentifier = "LeftImageMessageTableViewCell"

    private let messageImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        
        setupMessageLabel()
    }
    
    private func setupMessageLabel() {
        self.bubbleView.addSubview(messageImageView)
        
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
            messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
    }
    
    
    public func configure(message: MessageViewModel) {
        messageImageView.image = UIImage(named: "testPic.jpg")
    }
    
    func handleReply() {
        print("Fake so far")
    }
    
}
