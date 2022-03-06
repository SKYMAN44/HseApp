//
//  File.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct File: Hashable {
    let id = UUID()
    let name: String
}

extension File: Decodable { }
