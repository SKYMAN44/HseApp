//
//  FormulaCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.01.2022.
//

import UIKit

final class FormulaCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FormulaCollectionViewCell"
    
    private let formulaLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .customFont.style(.caption)()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .background.style(.accent)()
        self.layer.cornerRadius = 8
        
        addSubview(formulaLabel)
        
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            formulaLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            formulaLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            formulaLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            formulaLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            formulaLabel.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 56)
        ])
    }
    
    public func configure(_ formula: Formula) {
        formulaLabel.text = formula.formula
    }
}
