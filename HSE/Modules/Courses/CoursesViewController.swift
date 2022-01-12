//
//  CoursesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

class CoursesViewController: UIViewController {
    

    @IBOutlet weak var segmentController: SegmentView!
    
    var courseViewModels = [CourseViewModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchCourses()

        segmentController.setTitles(titles: courseViewModels.map({
            return $0.title
        }))
        segmentController.delegate = self
    
    }
    
    private func fetchCourses() {
        //simulate network call by now
        let courses = Course.courses
        courseViewModels = courses.map({
            return CourseViewModel(course: $0 )
        })
    }
    
    func updateUI()
    {
       
    }
    
    
    // MARK: - Navigation
    
}

extension CoursesViewController: SegmentViewDelegate {
    
    func segmentChosen(index: Int) {
        print("Chosen segment: \(index)")
    }
    
    
}
