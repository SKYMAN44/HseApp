//
//  ChatCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ChatCollectionViewCell"
    
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .blue
        
        chatImageView.layer.masksToBounds = false
        chatImageView.layer.cornerRadius = chatImageView.frame.size.width / 2
        chatImageView.clipsToBounds = true
        
        chatImageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        notificationView.layer.cornerRadius = 12
        notificationView.backgroundColor = UIColor(named: "BackgroundAccent")
        
        notificationLabel.text = String(Int.random(in: 0...999))
        
        
    }

}
