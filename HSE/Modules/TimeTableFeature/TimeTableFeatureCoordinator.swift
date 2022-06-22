//
//  TimeTableFeatureCoordinator.swift
//  HSE
//
//  Created by Дмитрий Соколов on 10.06.2022.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }

    func start()
}


final class TimeTableFeatureCoordinator: Coordinator {
    var navigationController: UINavigationController

    var parentCoordinator: Coordinator?

    var children: [Coordinator] = []

    init(_ navagationController: UINavigationController) {
        self.navigationController = navagationController
        start()
    }

    func start() {
        
    }

    func goToAssigmnetDetail() {

    }

}
