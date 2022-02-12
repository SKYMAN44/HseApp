//
//  Array.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import Foundation

extension Array {
    init(repeatingExpression expression: @autoclosure (() -> Element), count: Int) {
        var temp = [Element]()
        for _ in 0..<count {
            temp.append(expression())
        }
        self = temp
    }
}
