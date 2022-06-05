//
//  StrokeAnimation.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import UIKit

final class StrokeAnimation: CABasicAnimation {
    enum StrokeType {
        case start
        case end
    }
    
    // MARK: - Init
    init(type: StrokeType,
         beginTime: Double = 0.0,
         fromValue: CGFloat,
         toValue: CGFloat,
         duration: Double
    ) {
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
