//
//  SegmentCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import UIKit

class SegmentCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "SegmentCollectionViewCell"

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                self.backView.backgroundColor = .blue
                self.backView.alpha = 0.1
                self.titleLabel.textColor = .blue
            }else {
                self.backView.alpha = 0.0
                self.titleLabel.textColor = .darkGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.backView.alpha = 0.0
        self.backView.layer.cornerRadius = 15
        self.layer.cornerRadius = 15
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }

}
