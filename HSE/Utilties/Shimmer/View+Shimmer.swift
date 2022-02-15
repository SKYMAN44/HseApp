//
//  View.swift
//  HSE
//
//  Created by Дмитрий Соколов on 08.02.2022.
//

import Foundation
import UIKit

extension UIView {
    func configureAndStartShimmering() {
        backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        startShimmering()
    }
    
    private func startShimmering() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor
        let dark = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.2, 0.6, 0.8]
        
        layer.addSublayer(gradient)
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "locations")
        animation.fromValue = [0.2, 0.4, 0.8]
        animation.toValue = [0.4, 1.0, 1.0]
        
        animation.duration = 1.5
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
    }

    
    
    func stopShimmering() {
        layer.cornerRadius = 0
        layer.sublayers?.forEach { (sublayer) in
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
    }
}
