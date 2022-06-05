//
//  ActivityAnimationScreen.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import UIKit

final class ActivityAnimationScreen: UIView {
    private var animationView: ActivityAnimationView
    
    public var isAnimating: Bool = false {
        didSet {
            animationView.isAnimating = isAnimating
        }
    }
    
    // MARK: - Init
    init(frame: CGRect, colors: [UIColor], lineWidth: CGFloat) {
        self.animationView = ActivityAnimationView(colors: colors, lineWidth: lineWidth)
        super.init(frame: frame)
        
        setupView()
    }
    
    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - setupView
    private func setupView() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.addSubview(animationView)
        
        animationView.pinCenter(to: self.centerYAnchor)
        animationView.pinCenter(to: self.centerXAnchor)
        animationView.setHeight(to: 50)
        animationView.setWidth(to: 50)
    }
}
