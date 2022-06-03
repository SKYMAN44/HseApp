//
//  File.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct File: Hashable {
    var id = UUID()
    let name: String
}

extension File: Decodable { }
