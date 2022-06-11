//
//  HostingCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 30.05.2022.
//

import UIKit

final class HostingCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HostingCollectionViewCell"
    
    weak var hostedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(view: UIView) {
        view.frame = contentView.bounds
        self.contentView.addSubview(view)
//        view.pin(to: contentView)
    }
}
