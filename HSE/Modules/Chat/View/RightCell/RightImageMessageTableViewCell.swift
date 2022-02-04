//
//  RightImageMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

final class RightImageMessageTableViewCell: BaseRightMessageTableViewCell, MessageCellProtocol {
    static var reuseIdentifier = "RightImageMessageTableViewCell"

    private let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true
        imageView.layer.cornerRadius = 12
        imageView.clearsContextBeforeDrawing = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    var imageViewHeightConstrain: NSLayoutConstraint?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        self.messageImageView.image = nil
    }
    
    private func setupMessageLabel() {
        self.bubbleView.addSubview(messageImageView)
        
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0),
            messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 0),
            messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0),
            messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: ScreenSize.Width / 2)
        ])
        
        imageViewHeightConstrain = NSLayoutConstraint(item: messageImageView,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: messageImageView,
                                                      attribute: .width,
                                                      multiplier: 1,
                                                      constant: 0)
        messageImageView.addConstraint(imageViewHeightConstrain!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        messageImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setImage(image: UIImage) {
        let ratio = image.size.width / image.size.height
        messageImageView.image = image
        imageViewHeightConstrain? = NSLayoutConstraint(item: messageImageView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: messageImageView,
                                                       attribute: .width,
                                                       multiplier: ratio,
                                                       constant: 0)
    }
    
    @objc
    private func imageTapped() {
        contentSelected()
    }
    
    public func configure(message: MessageViewModel) {
        setImage(image: message.imageArray!)
    }
    
    func handleReply() {
        print("Fake so far")
    }
    
    private func contentSelected() {
        self.delegate?.selectedContentInCell(content: messageImageView, indexPath: myIndexPath!)
    }
    
}
