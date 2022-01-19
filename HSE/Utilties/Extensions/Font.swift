//
//  Font.swift
//  HSE
//
//  Created by Дмитрий Соколов on 17.01.2022.
//

import Foundation
import UIKit

// переделать на extension label
extension UIFont {
    
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
    
}
