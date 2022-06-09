//
//  MessageViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import Foundation
import UIKit

enum Side {
    case left
    case right
}

enum MessageType {
    case text
    case image
}

final class MessageViewModell {
    let tableView: UITableView
    
    // MARK: - Init
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
}

// Actually just a model by now
struct MessageViewModel {
    let id = UUID()
    let side: Side
    let type: MessageType
    let text: String?
    let imageURL: URL?
    var imageArray: UIImage?
    
    
    static let testArray: [MessageViewModel] = [
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .right, type: .text, text: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .right, type: .text, text: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .right, type: .text, text: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .right, type: .text, text: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", imageURL: nil),
        MessageViewModel(side: .left, type: .image, text: nil, imageURL: URL(string: "fake")),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .right, type: .text, text: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil),
        MessageViewModel(side: .left, type: .text, text: "Я все скипнул, мне доступ открыт и везде зеленый свет", imageURL: nil)
    ]
}
