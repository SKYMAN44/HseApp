//
//  PrimaryTextField.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import UIKit

final class PrimaryTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.borderStyle = .none
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
        self.setLeftPaddingPoints(16)
        self.setHeight(to: 48)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setColors(_ background: UIColor) {
        self.backgroundColor = background
    }
}
