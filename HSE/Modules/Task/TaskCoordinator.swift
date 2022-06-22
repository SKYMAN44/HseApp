//
//  TaskCoordinator.swift
//  HSE
//
//  Created by Дмитрий Соколов on 22.06.2022.
//

import Foundation
import UIKit

final class TaskCoordinator: Coordinator {
    var parentCoordinator: Coordinator?

    var children: [Coordinator] = []

    var navigationController: UINavigationController

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
    }
}
