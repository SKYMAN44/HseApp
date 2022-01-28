//
//  FormulaCollectionReusableView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.01.2022.
//

import UIKit

final class FormulaCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "FormulaCollectionReusableView"
    
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
            formulaLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    public func configure() {
        formulaLabel.text = "0.25*(0.3*Exam1 + 0.7*(0.3125*Oral1 + 0.25* W1 + 0.25*Q1 + 0.1875*H1)) +  0.75*(0.3*Exam2 + 0.7*(0.3125*Oral2 + 0.25*W2 + 0.25*Q2 +0.1875*H2)))"
    }
    
}
