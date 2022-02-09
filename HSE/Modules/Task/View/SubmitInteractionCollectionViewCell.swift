//
//  SubmitInteractionCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

protocol SubmitInteractionCollectionViewCellDelegate {
    func changeState()
}

final class SubmitInteractionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SubmitInteractionCollectionViewCell"
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .background.style(.accent)()
        button.setTitle("Edit Submission", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .customFont.style(.body)()
        button.setTitleColor(.textAndIcons.style(.primary)(), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    public var delegate: SubmitInteractionCollectionViewCellDelegate?
    private var isEditing: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubview(submitButton)
        
        submitButton.pin(to: contentView)
        submitButton.setWidth(to: ScreenSize.Width - 32)
        submitButton.setHeight(to: 48)
        changeState(isEditing: false)
    }
    
    @objc
    private func buttonTapped() {
        delegate?.changeState()
        isEditing.toggle()
        changeState(isEditing: isEditing)
    }
    
    public func changeState(isEditing: Bool) {
        if(isEditing) {
            submitButton.backgroundColor = .primary.style(.primary)()
            submitButton.setTitle("Submit Work", for: .normal)
            submitButton.setTitleColor(.primary.style(.onPrimary)(), for: .normal)
        } else {
            submitButton.backgroundColor = .background.style(.accent)()
            submitButton.setTitle("Edit Submission", for: .normal)
            submitButton.setTitleColor(.textAndIcons.style(.primary)(), for: .normal)
        }
    }
    
}

