//
//  LeftTextMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

final class LeftTextMessageTableViewCell: BaseLeftMessageTableViewCell, MessageCellProtocol {
    static var reuseIdentifier = "LeftTextMessageTableViewCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .customFont.style(.message)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
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
        self.bubbleView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
        
    }
    
    public func configure(message: MessageViewModel) {
        messageLabel.text = message.text
    }
    
    func handleReply() {
        print("Fake so far")
    }
    
}

