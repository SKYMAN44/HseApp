//
//  AddFileCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.04.2022.
//

import UIKit

class AddFileCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AddFileCollectionViewCell"
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .background.style(.accent)()
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .textAndIcons.style(.secondary)()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

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
    
    private func setupView() {
        self.contentView.addSubview(addButton)
        
        addButton.pin(to: self.contentView)
    }
    
    @objc
    private func addButtonTapped() {
        
    }
}
