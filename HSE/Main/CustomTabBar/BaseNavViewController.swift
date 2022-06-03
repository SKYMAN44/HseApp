//
//  ScheduleNavViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import UIKit
import HSESKIT

class BaseNavViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    private func setupAppearance() {
        // breaks nested scrolling
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .background.style(.accent)()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = nil
        appearance.shadowColor = .none
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.isTranslucent = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
