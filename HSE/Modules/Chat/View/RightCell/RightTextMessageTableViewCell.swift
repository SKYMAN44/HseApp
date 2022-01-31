//
//  RightTextMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

final class RightTextMessageTableViewCell: BaseRightMessageTableViewCell, MessageCellProtocol {
    static var reuseIdentifier = "RightTextMessageTableViewCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .customFont.style(.footnote)()
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
    
    func configure(message: MessageViewModel) {
        messageLabel.text = message.text
    }
    
    func handleReply() {
        print("Fake so far")
    }
    
    func replySelected(from action: UIAction) { }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let children: [UIMenuElement] = [self.makeReplyAction()]
            return UIMenu(title: "", children: children)
        })
    }
    
    func makeReplyAction() -> UIAction {
        return UIAction(
        title: "Reply",
        image: UIImage(systemName: "arrowshape.turn.up.left"),
        identifier: nil,
        handler: replySelected)
    }
}
