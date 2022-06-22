//
//  CourseFeatureProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 20.06.2022.
//

import UIKit

protocol CoursesModuleScreen: UIViewController {
    init(_ role: UserType)

    func setSegments(content: [(String, Int)])
}

protocol CoursesModuleLogic {
    init(_ networkManager: SubjectsNetworkManager,
         _ courseScreen: CoursesModuleScreen,
         _ collectionView: UICollectionView
    )
}

protocol CoursePresentationLogic {
    init(_ courseId: Int, _ networkManager: SubjectsNetworkManager, _ collectionView: UICollectionView)
}

internal enum CourseSection: Hashable {
    case chat
    case description
    case tStuff
    case formula
}
