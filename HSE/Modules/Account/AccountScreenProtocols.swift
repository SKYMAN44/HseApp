//
//  AccountScreenProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol AccountScreen: UIViewController, TimeTableViewControllerScrollDelegate  {
    var embededScrollView: UIScrollView? { get set }
    
    init(userReference: UserReference?)
}

protocol AccountLogic {
    init(
        _ collectionView: UICollectionView,
        _ viewController: AccountScreen,
        _ userNetworkManager: UserNetworkManager,
        _ userReference: UserReference?
    )
}

internal enum AccountSupplementaryViewKind {
    static let segments = "segments"
}
