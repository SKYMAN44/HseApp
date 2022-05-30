//
//  HostingCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 30.05.2022.
//

import UIKit

final class HostingCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HostingCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
//        let timeVC = TimeTableViewController()
//        self.contentView.addSubview(timeVC.view)
//        timeVC.view.pin(to: contentView)
    }
}
