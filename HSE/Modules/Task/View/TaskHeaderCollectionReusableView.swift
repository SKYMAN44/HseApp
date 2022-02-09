//
//  TaskHeaderCollectionReusableView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

final class TaskHeaderCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "askHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.textAlignment = .left
        label.text = "TASK FILES"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
}
