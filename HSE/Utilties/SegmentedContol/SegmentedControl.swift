//
//  CustomSegmentedController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

@IBDesignable
class SegmentedControl: UIControl {

    var buttons = [UIButton]()
    var selector: UIView!
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var borderWidth: CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var titlesCS: String = "" {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .systemGray6 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var selectorTextColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview()})
        
        let titles = titlesCS.components(separatedBy: ",")
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .customFont.style(.body)()
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        selector = UIView(frame: CGRect(x: 0, y: 0, width: frame.width / CGFloat(buttons.count), height: frame.height))
        selector.layer.cornerRadius = 8
        selector.backgroundColor = selectorColor
        selector.alpha = 0.5
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    override func draw(_ rect: CGRect) {
        
    }
    
    @objc func buttonTapped(button: UIButton) {
        
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        for (bIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if(btn == button) {
                selectedSegmentIndex = bIndex
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = self.frame.width / CGFloat(self.buttons.count) * CGFloat(bIndex)
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }

}
