//
//  Label.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.01.2022.
//

import Foundation
import UIKit

extension UILabel {
    
    enum customFont {
        case headline
        case title
        case body
        case footnote
        case caption
        case special
        
        func style() -> UIFont {
            let font: UIFont
            switch self {
            case .headline:
                font = UIFont(name: "Inter-Bold", size: 28)!
            case .title:
                font = UIFont(name: "Inter-SemiBold", size: 16)!
            case .body:
                font = UIFont(name: "Inter-Medium", size: 16)!
            case .footnote:
                font =  UIFont(name: "Inter-Regular", size: 14)!
            case .caption:
                font = UIFont(name: "Inter-Medium", size: 12)!
            case .special:
                font = UIFont(name: "Inter-Medium", size: 14)!
            }
            return font
        }
    }
    
    
    func setCustomAttributedText(string: String, fontSize: CGFloat, _ lineHeightMultiplicator: CGFloat) {
        let attributedString = NSMutableAttributedString(string: string)
        self.numberOfLines = 0
        self.font = .systemFont(ofSize: fontSize)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiplicator
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
}
