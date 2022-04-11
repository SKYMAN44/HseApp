//
//  SubmissionCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.04.2022.
//

import UIKit

class SubmissionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SubmissionCollectionViewCell"
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .primary.style(.primary)()
        label.textAlignment = .left
        
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(systemName: "xmark"), for: .normal)
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
    
    // MARK: - UI
    private func setupView() {
        backgroundColor = .background.style(.accent)()
        layer.cornerRadius = 8
        
        let sV = UIStackView(arrangedSubviews: [fileNameLabel, deleteButton])
        sV.distribution = .fill
        sV.axis = .horizontal
        sV.spacing = 10
        
        contentView.addSubview(sV)
        
        sV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            sV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            sV.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            sV.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32).isActive = true
        
        deleteButton.isHidden = true
    }
    
    // MARK: - External
    public func configure(file: File, isEditing: Bool) {
        fileNameLabel.text = file.name
        deleteButton.isHidden = isEditing ? false : true
    }
}
