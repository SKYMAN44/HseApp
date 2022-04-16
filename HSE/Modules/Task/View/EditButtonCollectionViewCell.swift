//
//  EditButtonCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.04.2022.
//

import UIKit

protocol EditButtonDelegate: AnyObject {
    func editModeSwitched()
}

final class EditButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "EditButtonCollectionViewCell"
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary.style(.primary)()
        button.setTitle("Submit Work", for: .normal)
        button.setTitleColor(.primary.style(.onPrimary)(), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)

        return button
    }()
    
    var delegate: EditButtonDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubview(editButton)
        
        editButton.pin(to: self.contentView)
    }
    
    public func configure(isEditing: Bool) {
        if(isEditing) {
            editButton.backgroundColor = .primary.style(.primary)()
            editButton.setTitle("Submit Work", for: .normal)
            editButton.setTitleColor(.primary.style(.onPrimary)(), for: .normal)
        } else {
            editButton.setTitle("Edit Submission", for: .normal)
            editButton.backgroundColor = .background.style(.accent)()
            editButton.setTitleColor(.textAndIcons.style(.primary)(), for: .normal)
        }
    }
    
    @objc
    private func editButtonPressed() {
        delegate?.editModeSwitched()
    }
}
