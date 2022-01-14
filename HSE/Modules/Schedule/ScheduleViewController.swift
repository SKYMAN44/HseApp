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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navView = ExtendingNavBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 108))
        navView?.color = UIColor(named: "BackgroundAccent")!
        navView?.addSubviews()
        navView?.addTarget(self, action: #selector(calendarButtonTapped) , for: .touchUpInside)
        navView?.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(navView!)
        
        navView?.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            navView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            navView!.heightAnchor.constraint(equalToConstant: 108)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func calendarButtonTapped() {
        CalendarPopUpView.init().show()
    }
    
    @objc func segmentChanged() {
        switch navView?.choosenSegment {
        case 0:
            print("TimeTable")
        case 1:
            print("Assigment")
        default:
            print("looks like error")
        }
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
