//
//  MessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MessageTableViewCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.tretiary)()
        
        return label
    }()
    
    private let senderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .customFont.style(.footnote)()
        label.textColor = .primary.style(.primary)()
        
        return label
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    private let senderImage: UIImageView = {
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
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        bubbleView.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.senderImage.removeFromSuperview()
        
        // for future cancelation of network requests (i.e images,videos, etc)
    }
    
    // view setUp in init (redo)
    private func setupView(sender: SenderType) {
        
        self.backgroundColor = .background.style(.firstLevel)()
        
        let textSV = UIStackView(arrangedSubviews: [senderLabel, timeLabel])
        textSV.alignment = .fill
        textSV.distribution = .fill
        textSV.axis = .horizontal
        textSV.spacing = 8
        
        
        let mainTextSV = UIStackView(arrangedSubviews: [textSV, messageLabel])
        mainTextSV.alignment = .leading
        mainTextSV.distribution = .fill
        mainTextSV.axis = .vertical
        mainTextSV.spacing = 8
        
        
        bubbleView.addSubview(mainTextSV)
        
        mainTextSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextSV.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            mainTextSV.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
            mainTextSV.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8),
            mainTextSV.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
        ])
        
        if(sender == .left) {
            let mainSV = UIStackView(arrangedSubviews: [senderImage, bubbleView])
            mainSV.alignment = .top
            mainSV.distribution = .fill
            mainSV.axis = .horizontal
            mainSV.spacing = 8
            
            senderImage.translatesAutoresizingMaskIntoConstraints = false
            senderImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
            
            addSubview(mainSV)
            
            mainSV.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                mainSV.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                mainSV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                mainSV.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
                mainSV.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -100)
            ])
            bubbleView.backgroundColor = .background.style(.accent)()
            
        } else {
            addSubview(bubbleView)
            bubbleView.backgroundColor = .primary.style(.filler)()
            bubbleView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
                bubbleView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 100)
            ])
        }
        layoutSubviews()
        
        
    }
    
    
    public func configure(message: Message) {
        messageLabel.text = message.message
        senderLabel.text = message.senderName
        timeLabel.text = message.time
        
        setupView(sender: message.senderType)
    }
    
    func replySelected(from action: UIAction) { }
    

}

extension MessageTableViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let children: [UIMenuElement] = [self.makeRemoveRatingAction()]
            return UIMenu(title: "", children: children)
        })
    }
    
    func makeRemoveRatingAction() -> UIAction {
        return UIAction(
        title: "Reply",
        image: UIImage(systemName: "arrowshape.turn.up.left"),
        identifier: nil,
        handler: replySelected)
    }
    
}
