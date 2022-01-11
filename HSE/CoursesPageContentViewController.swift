//
//  CoursesPageContentViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

class CoursesPageContentViewController: UIViewController {

    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(Int.random(in: 0...255)), green: CGFloat(Int.random(in: 0...255)), blue:  CGFloat(Int.random(in: 0...255)), alpha: 1)
        print("CalledBlyatController__________________________________________________")
    }
    
}
