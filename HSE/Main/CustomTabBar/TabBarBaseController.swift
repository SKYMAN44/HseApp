//
//  TabBarBaseController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//
import Foundation
import UIKit

final class TabBarBaseController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = true
        tabBar.tintColor = .primary.style(.primary)()
        tabBar.backgroundColor = .background.style(.accent)()

        let courseViewController = CoursesViewController()
        let navControllerCourses = BaseNavViewController(rootViewController: courseViewController)
        let gradesViewController = GradesViewController()
        let accountViewController = AccountViewController()
        let scheduleViewController = ScheduleViewController()
        let navControllerSchedule = BaseNavViewController(rootViewController: scheduleViewController)
        let navControllerGrades = BaseNavViewController(rootViewController: gradesViewController)

        navControllerSchedule.tabBarItem.image = UIImage(named: "calendarCS")
        navControllerSchedule.tabBarItem.selectedImage = UIImage(named: "calendarCS")

        navControllerGrades.tabBarItem.image = UIImage(named: "awardCS")
        navControllerGrades.tabBarItem.selectedImage = UIImage(named: "awardCS")

        accountViewController.tabBarItem.image = UIImage(named: "userCS")
        accountViewController.tabBarItem.selectedImage = UIImage(named: "userCS")

        navControllerCourses.tabBarItem.image = UIImage(named: "serverCS")
        navControllerCourses.tabBarItem.selectedImage = UIImage(named: "serverCS")

        self.setViewControllers(
            [navControllerSchedule,
             navControllerCourses,
             navControllerGrades,
             accountViewController
            ],
            animated: false
        )

        for (tabBarItem) in tabBar.items! {
            tabBarItem.title = ""
        }

        self.selectedIndex = 0
    }
}
