//
//  CoursesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit
import HSESKIT

final class CoursesViewController: UIViewController {
    private var segmentView: PaginationView!
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
    private let role: UserType

    // MARK: - Init
    init(_ role: UserType) {
        self.role = role
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCourses()
        configureUI()

        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
    }

    // MARK: - UI setup
    private func configureUI() {
        self.view.backgroundColor = .background.style(.accent)()
        setupNavBar()

        setupSegmentView()
        setupCollectionView()
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationItem.title = "Courses"

        if(role == .professor) {
            let settingsImage = UIImage(named: "editIcon")?.withTintColor(.black)
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: settingsImage,
                style: .plain,
                target: self,
                action: #selector(editCourseButtonPressed)
            )
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }

    private func setupSegmentView() {
        var mode: PaginationView.Mode = .read
        if(self.role == .professor) {
            mode = .edit
        }
        segmentView = PaginationView(mode)
        segmentView.setTitles(
            titles:
                courseViewModels.map({
                    PageItem(
                        title: $0.title,
                        notifications: $0.counter
                    )
                })
        )

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
    // MARK: - Interactions
    @objc
    private func editCourseButtonPressed() {}

    // MARK: - API Call
    private func fetchCourses() {
        // simulate network call by now
        let courses = Course.courses
        courseViewModels = courses.map({
            return CourseViewModel(course: $0 )
        })
    }
}

// MARK: - Scroll Delegate
extension CoursesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // track change of pages
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        segmentView.moveTo(page)
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

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CourseCollectionViewCell.reuseIdentifier,
            for: indexPath
         ) as! CourseCollectionViewCell

        cell.delegate = self

        return cell
    }
}

extension CoursesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - SegmentView delegate
extension CoursesViewController: PaginationViewDelegate {
    func segmentChosen(index: Int) {
        courseCollectionView.scrollToItem(
            at: IndexPath(row: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    func addItemChosen() {
        print("Add new")
        let addCourse = AddCourseViewController()

        self.navigationController?.present(addCourse, animated: true)
    }
}

// MARK: - CourseCellDelegate + Navigation
extension CoursesViewController: CourseCollectionVeiwCellDelegate {
    func chatSelected() {
        let chatViewController = ChatViewController()

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatViewController, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
