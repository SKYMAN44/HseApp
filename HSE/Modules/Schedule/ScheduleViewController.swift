//
//  ScheduleViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var navView: ExtendingNavBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navView = ExtendingNavBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        navView?.color = UIColor(named: "BackgroundAccent")!
        navView?.addTarget(self, action: #selector(calendarButtonTapped) , for: .touchUpInside)
        navigationController?.navigationBar.addSubview(navView!)
    }
    
    
    @objc func calendarButtonTapped() {
        CalendarPopUpView.init().show()
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
