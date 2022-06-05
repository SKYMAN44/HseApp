//
//  Textfield.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func applyCustomClearButton() {
        clearButtonMode = .never
        rightViewMode   = .whileEditing
        
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        clearButton.setImage(UIImage(named: "closeIcon")!, for: .normal)
        clearButton.setImage(UIImage(named: "closeIcon")?.withTintColor(.yellow), for: .highlighted)
        clearButton.tintColor = .primary.style(.primary)()
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: self.frame.size.height))
        paddingView.addSubview(clearButton)
        
        clearButton.translatesAutoresizingMaskIntoConstraints = true
                NSLayoutConstraint.activate([
                    clearButton.topAnchor.constraint(equalTo: paddingView.topAnchor),
                    clearButton.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
                    clearButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
                    clearButton.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor),
                ])
        
        
        rightView = paddingView
    }

    @objc func clearClicked(sender:UIButton) {
        text = ""
    }
    
    static let onImage = UIImage(named: "eye-on")
    static let offImage = UIImage(named: "eye-off")
    
    func applySecureEntrySwitcher() {
        let showPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.height))
        showPasswordButton.backgroundColor = UIColor.clear
        showPasswordButton.setImage(Self.offImage!.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonPressed), for: .touchDown)
        
        rightView = showPasswordButton
        rightViewMode = .always
        translatesAutoresizingMaskIntoConstraints = false
        rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func showPasswordButtonPressed()
    {
        isSecureTextEntry.toggle()
        if let button = rightView as? UIButton
        {
            if button.imageView?.image == Self.onImage {
                button.setImage(Self.offImage, for: .normal)
            } else {
                button.setImage(Self.onImage, for: .normal)
            }
        }
    }
}
