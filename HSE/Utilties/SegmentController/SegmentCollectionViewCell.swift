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
                self.backView.backgroundColor = UIColor(named: "PrimaryFiller")
                self.backView.alpha = 1
                self.titleLabel.textColor = UIColor(named: "Primary")
                notificationView.backgroundColor = .white
            }else {
                self.backView.alpha = 1
                notificationView.backgroundColor = .systemGray6
                self.backView.backgroundColor = .white
                self.titleLabel.textColor = .lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        notificationView.layer.cornerRadius = 12
        notificationView.backgroundColor = .systemGray6
        self.backView.alpha = 0.0
        self.backView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        
        notificationLabel.text = String(Int.random(in: 0...999))
    }
    
    public func configure(title: String) {
        self.titleLabel.text = title
    }

}
