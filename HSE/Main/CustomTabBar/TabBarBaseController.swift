//
//  TabBarBaseController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//
import Foundation
import UIKit

class TabBarBaseController: UITabBarController {

    var scheduleViewController: ScheduleViewController!
    var gradesViewController: GradesViewController!
    var accountViewController: AccountViewController!
    var coursesViewController: CoursesViewController

    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .white
        
        scheduleViewController =  ScheduleViewController()
        gradesViewController =  GradesViewController()
        accountViewController = AccountViewController()
        coursesViewController =  CoursesViewController()
        
        scheduleViewController.tabBarItem.image = UIImage(systemName: "calendar")
//        scheduleViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        gradesViewController.tabBarItem.image = UIImage(systemName: "award")
//        gradesViewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass")
        
        accountViewController.tabBarItem.image = UIImage(systemName: "user")
//        accountViewController.tabBarItem.selectedImage = UIImage(systemName: "text.bubble.fill")
        
        coursesViewController.tabBarItem.image = UIImage(systemName: "server")
//        coursesViewController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        
        viewControllers = [scheduleViewController, gradesViewController, accountViewController, coursesViewController]
    }
    
}

extension TabBarBaseController: UITabBarControllerDelegate {
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
}
