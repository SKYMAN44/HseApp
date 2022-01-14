//
//  ExtendingNavBar.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.01.2022.
//

import UIKit

class ExtendingNavBar: UIControl {

    var mainView: UIView!
    var slidingView: UIView!
    var chooseButton: UIButton!
    var calendarButton: UIButton!
    
    var selectedIndex = 0
    
    private var slideViewisVisible: Bool = false
    
    var mainLabel: UILabel =  {
        let label = UILabel()
        label.text = "TimeTable"
        return label
    }()
    
    var minorLabel: UILabel = {
        let label = UILabel()
        label.text = "Assigments"
        return label
    }()
    
    var color: UIColor = .white

    override func draw(_ rect: CGRect) {
        
        slidingView = UIView(frame: rect)
        mainView = UIView(frame: rect)
        
        slidingView.backgroundColor = color
        mainView.backgroundColor = color
        
        addSubview(slidingView)
        addSubview(mainView)
        
        chooseButton = UIButton(type: .system)
        chooseButton.setImage(UIImage(named: "chevron-down"), for: .normal)
        chooseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        calendarButton = UIButton(type: .system)
        calendarButton.setImage(UIImage(named: "calendarCS"), for: .normal)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        
        mainView.addSubview(calendarButton)
        
        let stackView = UIStackView(arrangedSubviews: [mainLabel,chooseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        
        mainView.addSubview(stackView)
        slidingView.addSubview(minorLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.75).isActive = true
        
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        calendarButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -15).isActive = true
        
        minorLabel.translatesAutoresizingMaskIntoConstraints = false
        minorLabel.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor).isActive = true
        minorLabel.centerYAnchor.constraint(equalTo: slidingView.centerYAnchor).isActive = true
    }
    
    @objc func buttonTapped() {
        if(slideViewisVisible) {
            slideViewisVisible = false
            UIView.animate(withDuration: 0.3) {
                self.slidingView.frame.origin.y = 0
                self.chooseButton.transform = CGAffineTransform.identity
            }
        } else {
            slideViewisVisible = true
            UIView.animate(withDuration: 0.3) {
                self.slidingView.frame.origin.y = self.frame.height
                self.chooseButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            }
        }
    }
    
    @objc func calendarButtonTapped() {
        sendActions(for: .touchUpInside)
    }
    
    
    
    
    
    

}
