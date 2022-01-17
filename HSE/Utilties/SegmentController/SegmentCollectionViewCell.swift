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
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                self.backView.backgroundColor = .primary.style(.filler)()
                self.backView.alpha = 1
                self.titleLabel.textColor = .primary.style(.primary)()
                notificationView.backgroundColor = .background.style(.firstLevel)()
            }else {
                self.backView.alpha = 1
                notificationView.backgroundColor = .background.style(.accent)()
                self.backView.backgroundColor = .background.style(.firstLevel)()
                self.titleLabel.textColor = .textAndIcons.style(.secondary)()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        notificationView.layer.cornerRadius = 12
        notificationView.backgroundColor = .background.style(.accent)()
        self.backView.alpha = 0.0
        self.backView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        
        titleLabel.font = .customFont.style(.body)()
        notificationLabel.font = .customFont.style(.caption)()
        
        notificationLabel.text = String(Int.random(in: 0...999))
    }
    
    public func configure(title: String) {
        self.titleLabel.text = title
    }

}
