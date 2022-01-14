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
    var leftView: UIView!
    var topView: UIView!
    var backView: UIView!
    var slidingButton: UIButton!
    
    var indicatorImageView: UIImageView!
    
    var calendarButton: UIButton!
    var mainButton: UIButton!
    
    private var slideViewIsVisible: Bool = false
    private var animationCompleted: Bool = true
    
    public var choosenSegment = 0
    
    var mainLabel: UILabel =  {
        let label = UILabel()
        label.text = "TimeTable"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var minorLabel: UILabel = {
        let label = UILabel()
        label.text = "Assigments"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var color: UIColor = .white

    override func draw(_ rect: CGRect) {
    }
    
    public func addSubviews() {
        
        // set up background views

        slidingView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 48))
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 60))
        
        slidingView.backgroundColor = color
        mainView.backgroundColor = color
        addSubview(slidingView)
        addSubview(mainView)
        
        // set up calendar button
        
        calendarButton = UIButton(type: .system)
        calendarButton.setImage(UIImage(named: "calendarCS"), for: .normal)
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        
        mainView.addSubview(calendarButton)
        
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        calendarButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -15).isActive = true
        
        // set up stackView
        
        mainButton = UIButton()
        mainButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        leftView = UIView()
        
        indicatorImageView = UIImageView(image: UIImage(named: "chevron-down"))
        indicatorImageView.contentMode = .center
        
        let sV = UIStackView()
        sV.addArrangedSubview(leftView)
        sV.addArrangedSubview(indicatorImageView)
        
        sV.axis = .horizontal
        sV.distribution = .fill
        sV.alignment = .fill
        sV.spacing = 0
        
        mainView.addSubview(sV)
        mainView.addSubview(mainButton)
        
        sV.translatesAutoresizingMaskIntoConstraints = false
        sV.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        sV.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true

        sV.widthAnchor.constraint(equalToConstant: 150).isActive = true
        sV.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        mainButton.rightAnchor.constraint(equalTo: sV.rightAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: sV.topAnchor).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: sV.bottomAnchor).isActive = true
        mainButton.leftAnchor.constraint(equalTo: sV.leftAnchor).isActive = true
        
        // setup changing labels
        
        topView = UIView()
        topView.backgroundColor = color
        
        backView = UIView()
        backView.backgroundColor = color
        
        
        topView.addSubview(mainLabel)
        backView.addSubview(minorLabel)
        
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        minorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        minorLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        minorLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor).isActive = true
        
        leftView.addSubview(backView)
        leftView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false

        topView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        topView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: leftView.widthAnchor, multiplier: 1).isActive = true
        topView.heightAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 1).isActive = true

        backView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        backView.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        backView.widthAnchor.constraint(equalTo: leftView.widthAnchor, multiplier: 1).isActive = true
        backView.heightAnchor.constraint(equalTo: leftView.heightAnchor, multiplier: 1).isActive = true
        
    }
    
    @objc func buttonTapped() {
        
        if(!animationCompleted) {
            return
        }
        
        if(slideViewIsVisible) {
            
            animationCompleted = false
            slideViewIsVisible = false
            slidingButton.removeFromSuperview()
            backView?.layer.zPosition = 0
            slidingButton.removeFromSuperview()
            UIView.animate(withDuration: 0.3, animations: {
                self.backView.frame.origin.y = 0
                self.indicatorImageView.transform = CGAffineTransform.identity
            })
            UIView.animate(withDuration: 0.3, delay: 0.01, animations: {
                self.slidingView.frame.origin.y = 0
            }) { _ in
                self.animationCompleted = true
                for constraint in self.constraints {
                    if constraint.identifier == "heightConstrain" {
                       constraint.constant = 60
                    }
                }
            }
        } else {
            animationCompleted = false
            UIView.animate(withDuration: 0.3, animations: {
                self.slidingView.frame.origin.y = self.mainView.frame.height
                self.indicatorImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            })
            UIView.animate(withDuration: 0.3, delay: 0.01, animations: {
                self.backView?.frame.origin.y = self.leftView.frame.height
            }) { _ in
                
                self.backView?.layer.zPosition = 1
                
                self.slideViewIsVisible = true
                
                self.slidingButton = UIButton()
                self.slidingButton.addTarget(self, action: #selector(self.slidedButtonTapped), for: .touchUpInside)
                
                for constraint in self.constraints {
                    if constraint.identifier == "heightConstrain" {
                       constraint.constant = 108
                    }
                }
                
                self.addSubview(self.slidingButton)
                
                
                self.slidingButton.translatesAutoresizingMaskIntoConstraints = false
                
                self.slidingButton.centerXAnchor.constraint(equalTo: self.slidingView.centerXAnchor).isActive = true
                self.slidingButton.topAnchor.constraint(equalTo: self.slidingView.topAnchor).isActive = true
                self.slidingButton.widthAnchor.constraint(equalTo: self.slidingView.widthAnchor, multiplier: 1).isActive = true
                self.slidingButton.heightAnchor.constraint(equalTo: self.slidingView.heightAnchor, multiplier: 1).isActive = true
                self.animationCompleted = true
            }
            
        }
    }
    
    @objc func slidedButtonTapped() {
        
        if(!animationCompleted) {
            return
        }
        animationCompleted = false
        slidingButton.removeFromSuperview()
        
        self.backView.layer.zPosition = 1
        self.topView.layer.zPosition = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.frame.origin.y = 0
            self.indicatorImageView.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.3, delay: 0.01, animations: {
            self.slidingView.frame.origin.y = 0
        }) { _ in
            self.animationCompleted = true
            if(self.choosenSegment == 0) {
                self.choosenSegment = 1
            } else {
                self.choosenSegment = 0
            }
            self.sendActions(for: .valueChanged)
            
            for constraint in self.constraints {
                if constraint.identifier == "heightConstrain" {
                   constraint.constant = 60
                }
            }
        }
        
        let temp = topView
        topView = backView
        backView = temp
        slideViewIsVisible = false
    }
    
    @objc func calendarButtonTapped() {
        sendActions(for: .touchUpInside)
    }
    
    
    
    
    
    

}
