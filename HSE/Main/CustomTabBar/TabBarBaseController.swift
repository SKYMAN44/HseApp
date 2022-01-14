//
//  TabBarBaseController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//
import Foundation
import UIKit

class TabBarBaseController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(named: "Primary")
        tabBar.backgroundColor = UIColor(named: "BackgroundAccent")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let scheduleViewController: ScheduleViewController =  storyboard.instantiateViewController(withIdentifier: "ScheduleViewController") as! ScheduleViewController
        let gradesViewController: GradesViewController =  storyboard.instantiateViewController(withIdentifier: "GradesViewController") as! GradesViewController
        let accountViewController: AccountViewController = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        let navcontroller: NavViewController = storyboard.instantiateViewController(withIdentifier: "NavViewController") as! NavViewController
        
        let navcontrollerschedule = storyboard.instantiateViewController(withIdentifier: "NavBarSchedule") as! UIViewController
        
//        scheduleViewController.tabBarItem.image = UIImage(named: "calendarCS")
//        scheduleViewController.tabBarItem.selectedImage = UIImage(named: "calendarCS")
        navcontrollerschedule.tabBarItem.image = UIImage(named: "calendarCS")
        navcontrollerschedule.tabBarItem.selectedImage = UIImage(named: "calendarCS")
        
        gradesViewController.tabBarItem.image = UIImage(named: "awardCS")
        gradesViewController.tabBarItem.selectedImage = UIImage(named: "awardCS")
        
        accountViewController.tabBarItem.image = UIImage(named: "userCS")
        accountViewController.tabBarItem.selectedImage = UIImage(named: "userCS")
        
        navcontroller.tabBarItem.image = UIImage(named: "serverCS")
        navcontroller.tabBarItem.selectedImage = UIImage(named: "serverCS")
        
        self.setViewControllers([navcontrollerschedule,gradesViewController,navcontroller,accountViewController], animated: false)

        for (index, tabBarItem) in tabBar.items!.enumerated() {
            tabBarItem.title = ""
        }

        self.selectedIndex = 0
    }
    
}
