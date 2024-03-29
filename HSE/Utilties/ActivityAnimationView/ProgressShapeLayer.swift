//
//  ProgressShapeLayer.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import UIKit

final class ProgressShapeLayer: CAShapeLayer {
    // MARK: - Init
    public init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
