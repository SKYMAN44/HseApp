//
//  TaskFeatureProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol TaskDetailModule: UIViewController {
    var headerKind: String { get }
    
    init(deadline: Deadline)
}

protocol TaskFeatureLogic {
    var sections: [TaskSection] { get }
    
    init(_ viewController: TaskDetailModule, _ collectionView: UICollectionView, deadline: Deadline)
}

internal enum TaskSection: String, Hashable {
    case taskInfo
    case publicationTime = "PUBLICATION TIME"
    case deadlineTime = "DEADLINE TIME"
    case taskFiles
    case creator
    case submission
    case submissionTime = "SUBMISSION TIME"
    case edit
}
