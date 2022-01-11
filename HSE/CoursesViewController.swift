//
//  CoursesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

class CoursesViewController: UIViewController {
    
    var coursesPageViewController: CoursesPageViewController?
    
    @IBOutlet weak var controllerCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        controllerCollectionView.delegate = self
        controllerCollectionView.dataSource = self
        controllerCollectionView.allowsMultipleSelection = false
    }
    
    func updateUI()
    {
       
    }
    
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destination = segue.destination
        if let pageViewController = destination as? CoursesPageViewController
        {
            coursesPageViewController = pageViewController
            coursesPageViewController?.coursesDelegate = self
        }
    }
    
}

extension CoursesViewController: CoursesPageViewControllerDelegate {
    
    func didUpdatePageIndex(currentIndex: Int) {
        controllerCollectionView.selectItem(at: IndexPath(row: currentIndex, section: 0), animated: true, scrollPosition: .top)
    }
}


extension CoursesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.coursesPageViewController?.moveToPage(index: indexPath.row)
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred(intensity: 0.5)
    }
    
}

extension CoursesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Course.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = controllerCollectionView.dequeueReusableCell(withReuseIdentifier: ControlCollectionViewCell.reuseIdentifier, for: indexPath) as! ControlCollectionViewCell
        
        cell.configure(course: Course.courses[indexPath.row])
        
        return cell
    }
    
    
}
