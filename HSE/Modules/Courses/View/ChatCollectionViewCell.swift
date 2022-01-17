//
//  ChatCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ChatCollectionViewCell"
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatNameLabel.font = .customFont.style(.body)()
        chatNameLabel.textColor = .textAndIcons.style(.primary)()
        
        senderNameLabel.font = .customFont.style(.footnote)()
        senderNameLabel.textColor = .textAndIcons.style(.primary)()
        
        messageContentLabel.font = .customFont.style(.footnote)()
        messageContentLabel.textColor = .textAndIcons.style(.secondary)()
        
        messageTimeLabel.font = .customFont.style(.footnote)()
        messageTimeLabel.textColor = .textAndIcons.style(.secondary)()
        
        
        chatImageView.layer.masksToBounds = false
        chatImageView.layer.cornerRadius = chatImageView.frame.size.width / 2
        chatImageView.clipsToBounds = true
        
        chatImageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        notificationView.layer.cornerRadius = 12
        notificationView.backgroundColor = .background.style(.accent)()
        
        notificationLabel.text = String(Int.random(in: 0...999))
        notificationLabel.font = .customFont.style(.caption)()
        notificationLabel.textColor = .textAndIcons.style(.secondary)()
        
        
    }

}
