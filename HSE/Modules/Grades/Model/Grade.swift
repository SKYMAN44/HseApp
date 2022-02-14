//
//  Grade.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.02.2022.
//

import Foundation


struct Grade {
    let id: Int
    let number: Int
    let name: String
    let grade: Int
}

extension Grade: Decodable { }

extension Grade: Hashable {}
