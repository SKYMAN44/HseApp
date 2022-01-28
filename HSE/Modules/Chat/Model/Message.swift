//
//  Message.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import Foundation

enum SenderType {
    case left
    case right
}

struct Message {
    
    let senderName: String
    let senderType: SenderType
    let message: String
    let attachment: URL?
    let time: String
    
    static let array: [Message] = [
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Пон", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "Найс ответ как обычно", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "У меня мама заболела непонятно чем, пока результаты теста придут, суббота уже пройдёт..", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "В конце мая вас погонят сдавать курсовые на антиплагиат, как приходит результат - вы отправляете это научнику, он ставит оценку и допуск на защиту Там вам тоже ставят оценку  Итоговая формула вроде была 0,3*научник + 0,7*защита", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .right, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19"),
        Message(senderName: "Dima Sokolov", senderType: .left, message: "Я все скипнул, мне доступ открыт и везде зеленый свет", attachment: nil, time: "17:19")
    
    ]
}


