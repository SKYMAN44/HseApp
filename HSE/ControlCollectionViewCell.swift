//
//  ControlCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

class ControlCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ControlCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                self.backgroundColor = .blue
                self.backgroundView?.layer.opacity = 0.6
            } else {
                self.backgroundColor = .systemGray6
                self.backgroundView?.layer.opacity = 1
            }
        }
    }
    
    @IBOutlet weak var courseNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        self.backgroundColor = .systemGray6
        
        self.layer.cornerRadius = 12
        
    }
    
    public func configure(course: Course)
    {
        courseNameLabel.text = course.name
    }
}
