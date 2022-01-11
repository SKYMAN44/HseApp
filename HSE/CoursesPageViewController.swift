//
//  CoursesPageViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

protocol CoursesPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int)
}

class CoursesPageViewController: UIPageViewController {

    var coursesDelegate: CoursesPageViewControllerDelegate?
//    var controllers = [CoursesPageContentViewController]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0)
        {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
            print("CCallled________-----------")
        }
    }
    
    func contentViewController(at index: Int)-> CoursesPageContentViewController?
    {
        if(index < 0 || index >= Course.courses.count)
        {
            return nil
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(identifier: "CoursesPageContentViewController") as? CoursesPageContentViewController{
            pageContentViewController.index = index
//            controllers.append(pageContentViewController)
            return pageContentViewController
        }
        return nil
    }
    
    func moveToPage(index: Int)
    {
        currentIndex = index
        if let nextViewController = contentViewController(at: currentIndex)
        {
            print("CalledBLYATSUKANAHUI______________________________________________")
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
}

extension CoursesPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CoursesPageContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CoursesPageContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    
}

extension CoursesPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? CoursesPageContentViewController
            {
                currentIndex = contentViewController.index
                coursesDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}
