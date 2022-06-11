//
//  TabBarBaseController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//
import Foundation
import UIKit

enum UserType: String, Hashable, Codable {
    case professor = "PROFESSOR"
    case assist = "TA"
    case student = "STUDENT"
}

final class TabBarBaseController: UITabBarController {
    private let userType: UserType

    // MARK: - Init
    init(_ userType: UserType) {
        self.userType = userType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO:  decompose and migrate to MVVM+C
        tabBar.isTranslucent = true
        tabBar.tintColor = .primary.style(.primary)()
        tabBar.backgroundColor = .background.style(.accent)()

        let courseViewController = CoursesViewController()
        let gradesViewController = GradesViewController()
        let accountViewController = AccountViewController()
        let mainViewController = MainScreenViewController()
        let navControllerCourses = BaseNavViewController(rootViewController: courseViewController)
        let navAccountViewController = BaseNavViewController(rootViewController: accountViewController)
        let navMainViewController = BaseNavViewController(rootViewController: mainViewController)
        let navControllerGrades = BaseNavViewController(rootViewController: gradesViewController)

        navMainViewController.tabBarItem.image = UIImage(named: "calendarCS")
        navMainViewController.tabBarItem.selectedImage = UIImage(named: "calendarCS")

        navControllerGrades.tabBarItem.image = UIImage(named: "awardCS")
        navControllerGrades.tabBarItem.selectedImage = UIImage(named: "awardCS")

        navAccountViewController.tabBarItem.image = UIImage(named: "userCS")
        navAccountViewController.tabBarItem.selectedImage = UIImage(named: "userCS")

        navControllerCourses.tabBarItem.image = UIImage(named: "serverCS")
        navControllerCourses.tabBarItem.selectedImage = UIImage(named: "serverCS")

        self.setViewControllers(
            [navMainViewController,
             navControllerCourses,
             navControllerGrades,
             navAccountViewController
            ],
            animated: false
        )
        for (tabBarItem) in tabBar.items! {
            tabBarItem.title = ""
        }
        self.selectedIndex = 0
    }
}
