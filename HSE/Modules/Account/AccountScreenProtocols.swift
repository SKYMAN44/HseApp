//
//  AccountScreenProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol AccountScreen: UIViewController {
    var embededScrollView: UIScrollView? { get set }
    
    init(userReference: UserReference?)
}

protocol AccountLogic {
//    init(
//        _ collectionView: UICollectionView,
//        _ viewController: AccountScreen,
//        _ userReference: UserReference?
//    )
}
