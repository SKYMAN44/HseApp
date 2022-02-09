//
//  SubmissionCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 08.02.2022.
//

import UIKit

final class SubmissionCollectionViewCell: UICollectionViewCell {
    static let reusdeIdentifier = "SubmissionCollectionViewCell"
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
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
        layer.cornerRadius = 8
        backgroundColor = .background.style(.accent)()
        self.contentView.setWidth(to: ScreenSize.Width - 32)
        
        let stackView = UIStackView(arrangedSubviews: [fileNameLabel, removeButton])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        stackView.pin(to: contentView, [.top: 15, .bottom: 15, .left: 12, .right: 12])
        removeButton.isHidden = true
    }
    
    
    // MARK: - Interface
    public func changeState(isEditing: Bool) {
        if(isEditing) {
            removeButton.isHidden = false
        } else {
            removeButton.isHidden = true
        }
    }
    
    
    public func configure(file: File) {
        fileNameLabel.text = file.name
    }
}
