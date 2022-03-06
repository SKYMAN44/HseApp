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
        label.font = .customFont.style(.formula)()
        label.textColor = .textAndIcons.style(.primary)()

        return label
    }()

    private let formulaTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.textAlignment = .left
        label.text = "Formula"

        return label
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.style(.accent)()
        view.layer.cornerRadius = 8

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backView.addSubview(formulaLabel)

        formulaLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            formulaLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            formulaLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 12),
            formulaLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -12),
            formulaLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12)
        ])

        let stackView = UIStackView(arrangedSubviews: [formulaTitleLabel, backView])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 12

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            stackView.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32)
        ])
    }

    public func configure(_ formula: Formula) {
        formulaLabel.text = formula.formula
    }
}
