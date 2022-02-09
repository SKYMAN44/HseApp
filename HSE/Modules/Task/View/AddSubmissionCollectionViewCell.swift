//
//  AddSubmissionCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 08.02.2022.
//

import UIKit

class AddSubmissionCollectionViewCell: UICollectionViewCell {
    static let reusdeIdentifier = "AddSubmissionCollectionViewCell"
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setWidth(to: 18)
        button.pinHeight(to: button.widthAnchor)
        button.tintColor = .textAndIcons.style(.primary)()
        
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    
    private func setupView() {
        self.backgroundColor = .background.style(.accent)()
        self.contentView.setWidth(to: ScreenSize.Width - 32)
        self.contentView.setHeight(to: 48)
        self.layer.cornerRadius = 8
        
        self.contentView.addSubview(addButton)
        addButton.pinCenter(to: contentView)
    }
}
