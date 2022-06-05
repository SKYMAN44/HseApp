//
//  TaskFeatureProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol TaskDetailModule: UIViewController {
    init(deadline: Deadline)
}

protocol TaskFeatureLogic {
    init(_ collectionView: UICollectionView, deadline: Deadline)
}
