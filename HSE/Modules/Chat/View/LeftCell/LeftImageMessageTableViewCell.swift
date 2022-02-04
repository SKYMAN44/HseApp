//
//  LeftImageMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

final class LeftImageMessageTableViewCell: BaseLeftMessageTableViewCell, MessageCellProtocol {
    static var reuseIdentifier = "LeftImageMessageTableViewCell"

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        
        setupMessageImageView()
    }
    
    private func setupMessageImageView() {
        self.bubbleView.addSubview(messageImageView)
        
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0),
            messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 0),
            messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 0),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0),
            messageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: ScreenSize.Width / 2)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        messageImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setImage(image: UIImage) {
        let ratio = image.size.width / image.size.height
        messageImageView.image = image
        messageImageView.addConstraint(NSLayoutConstraint(item: messageImageView,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: messageImageView,
                                                          attribute: .width,
                                                          multiplier: ratio,
                                                          constant: 0))
    }
    
    @objc
    private func imageTapped() {
        contentSelected()
    }
    
    
    public func configure(message: MessageViewModel) {
        setImage(image: UIImage(named: "testPic.jpg")!)
    }
    
    func handleReply() {
        print("Fake so far")
    }
    
    
    private func contentSelected() {
        self.delegate?.selectedContentInCell(content: messageImageView, indexPath: myIndexPath!)
    }

}