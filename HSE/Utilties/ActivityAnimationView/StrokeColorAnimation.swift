//
//  StrokeColorAnimation.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import UIKit

final class StrokeColorAnimation: CAKeyframeAnimation {
    
    // MARK: - Init
    override init() {
        super.init()
    }
    
    init(colors: [CGColor], duration: Double) {
        super.init()
        
        self.keyPath = "strokeColor"
        self.values = colors
        self.duration = duration
        self.repeatCount = .greatestFiniteMagnitude
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
