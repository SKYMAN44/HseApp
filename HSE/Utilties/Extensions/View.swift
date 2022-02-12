//
//  View.swift
//  HSE
//
//  Created by Дмитрий Соколов on 08.02.2022.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Pin magic layout
    
    enum PinnedSide {
        case top
        case left
        case right
        case bottom
    }
    
    func pin(to superView: UIView, _ sides: PinnedSide...) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superView)
            case .left:
                pinLeft(to: superView)
            case .right:
                pinRight(to: superView)
            case .bottom:
                pinBottom(to: superView)
            }
        }
    }
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        pinTop(to: superView)
        pinLeft(to: superView)
        pinRight(to: superView)
        pinBottom(to: superView)
    }
    
    
    func pin(
        to superView: UIView,
        _ sides: [PinnedSide],
        _ const: Double = 0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superView, const)
            case .left:
                pinLeft(to: superView, const)
            case .right:
                pinRight(to: superView, const)
            case .bottom:
                pinBottom(to: superView, const)
            }
        }
    }
    
    func pin(to superView: UIView, _ sides: [PinnedSide: Double]) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side.key {
            case .top:
                pinTop(to: superView, side.value)
            case .left:
                pinLeft(to: superView, side.value)
            case .right:
                pinRight(to: superView, side.value)
            case .bottom:
                pinBottom(to: superView, side.value)
            }
        }
    }
    
    func pin(
        to superView: UIView,
        excluding: PinnedSide,
        _ const: Double = 0
    ) {
        var sides: [PinnedSide] = [.top, .left, .right, .bottom]
        sides = sides.filter { $0 != excluding }
        pin(to: superView, sides, const)
    }
    
    @discardableResult
    func pinLeft(to superView: UIView, _ const: Double = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superView.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinLeft(to anchor: NSLayoutXAxisAnchor, _ const: Double = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: anchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinRight(
        to superView: UIView,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superView.trailingAnchor,
            constant: -CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinRight(
        to anchor: NSLayoutXAxisAnchor,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: anchor,
            constant: -CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(
        to superView: UIView,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superView.bottomAnchor,
            constant: -CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(
        to anchor: NSLayoutYAxisAnchor,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: anchor,
            constant: -CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinTop(
        to superView: UIView,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superView.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinTop(
        to anchor: NSLayoutYAxisAnchor,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: anchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    func resistShrinking(
        with priority: Double,
        axis: NSLayoutConstraint.Axis
    ) {
        setContentCompressionResistancePriority(
            UILayoutPriority(rawValue: Float(priority)),
            for: axis
        )
    }
    
    func allowGrowing(
        with priority: Double,
        axis: NSLayoutConstraint.Axis
    ) {
        setContentHuggingPriority(
            UILayoutPriority(rawValue: Float(priority)),
            for: axis
        )
    }
    
    @discardableResult
    func setHeight(to height: Double) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(
            equalToConstant: CGFloat(height)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setWidth(to width: Double) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(width))
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinHeight(
        to height: NSLayoutDimension,
        _ multiplier: Double = 1
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(
            equalTo: height,
            multiplier: CGFloat(multiplier)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinWidth(
        to width: NSLayoutDimension,
        _ multiplier: Double = 1
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(
            equalTo: width,
            multiplier: CGFloat(multiplier)
        )
        constraint.isActive = true
        return constraint
    }
    
    func pinCenter(to view: UIView, _ const: Double = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(
            equalTo: view.centerXAnchor,
            constant: CGFloat(const)
        ).isActive = true
        centerYAnchor.constraint(
            equalTo: view.centerYAnchor,
            constant: CGFloat(const)
        ).isActive = true
    }
    
    @discardableResult
    func pinCenter(
        to xAnchor: NSLayoutXAxisAnchor,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: xAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinCenter(
        to yAnchor: NSLayoutYAxisAnchor,
        _ const: Double = 0
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: yAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }
}


extension UIView {
    
    func configureAndStartShimmering() {
        
        backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        startShimmering()
    }
    
    func startShimmering() {
        
//        let light = UIColor(white: 0, alpha: 0.1).cgColor
        let light = UIColor(named: "OutlineLight")!.cgColor
        let dark = UIColor.background.style(.accent)().cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.525)
        gradient.locations  = [0.2, 0.5, 0.8]
        
        layer.mask = gradient
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "locations")
        animation.fromValue = [0.0, 0.2, 0.4]
        animation.toValue   = [0.6, 0.8, 1.0]
        
        animation.duration = 1.5
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
    }

    
    
    func stopShimmering() {
        layer.cornerRadius = 0
        layer.mask = nil
    }
}
