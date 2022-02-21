//
//  Item.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.02.2022.
//

import Foundation


struct Item {
    var title: String
    var notifications: Int
    var action: ((String) -> ())?
}
