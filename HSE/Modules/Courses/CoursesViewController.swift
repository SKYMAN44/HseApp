//
//  CoursesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit

final class CoursesViewController: UIViewController {
    
    private var segmentView: SegmentView!
    private var courseViewModels = [CourseViewModel]()
    private var courseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
    
        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: "CourseCollectionViewCell")

        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        configureUI()
        
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - UI setup
    
    private func configureUI() {
        self.view.backgroundColor = .background.style(.accent)()
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.title = "Courses"
        
        fetchCourses()
        
        setupSegmentView()
        setupCollectionView()
    }
    
    
    private func setupSegmentView() {
        segmentView = SegmentView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: 56))
        segmentView.setTitles(titles: courseViewModels.map({
            return $0.title
        }))
        
        segmentView.backgroundColor = .background.style(.accent)()
        segmentView.delegate = self
        
        view.addSubview(segmentView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            segmentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 56)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCollectionView() {
        view.addSubview(courseCollectionView)

        courseCollectionView.translatesAutoresizingMaskIntoConstraints = false
        courseCollectionView.backgroundColor = .white
        courseCollectionView.showsHorizontalScrollIndicator = false

        let collectionConstraints = [
            courseCollectionView.topAnchor.constraint(equalTo: segmentView.bottomAnchor),
            courseCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            courseCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            courseCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(collectionConstraints)
    }
    
    
    private func fetchCourses() {
        //simulate network call by now
        let courses = Course.courses
        courseViewModels = courses.map({
            return CourseViewModel(course: $0 )
        })
    }
    
}

extension CoursesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        segmentView.moveTo(index: page)
    }
    
}

// MARK: - CollectionView Delegate


extension CoursesViewController: UICollectionViewDelegate { }



// MARK: - CollectionView DataSource

extension CoursesViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return courseViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.reuseIdentifier, for: indexPath) as! CourseCollectionViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    
}

extension CoursesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}


// MARK: - SegmentView delegate

extension CoursesViewController: SegmentViewDelegate {
    
    func segmentChosen(index: Int) {
        courseCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}

// MARK: - CourseCellDelegate

extension CoursesViewController: CourseCollectionVeiwCellDelegate {
    func chatSelected() {
        let chatViewController = ChatViewController()
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
}
