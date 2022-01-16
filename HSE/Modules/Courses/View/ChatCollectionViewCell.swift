//
//  ChatCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ChatCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .blue
    }

}
