//
//  TeachingStuffCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

class TeachingStuffCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "TeachingStuffCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .green
    }

}
