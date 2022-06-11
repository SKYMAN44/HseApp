//
//  PrimaryButton.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import UIKit

final class PrimaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 8
        self.setHeight(to: 48)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setColors(_ background: UIColor, _ titleColor: UIColor) {
        self.backgroundColor = background
        self.setTitleColor(titleColor, for: .normal)
    }
}

