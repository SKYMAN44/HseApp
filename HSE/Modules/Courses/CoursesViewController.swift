//
//  CoursesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import UIKit
import HSESKIT

final class CoursesViewController: UIViewController, CoursesModuleScreen {
    private var segmentView: PaginationView!
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
    private var courseViewModel: CoursesModuleLogic?

    // MARK: - Init
    init(_ role: UserType) {
        self.role = role
        super.init(nibName: nil, bundle: nil)

        var mode: PaginationView.Mode = .read
        if(self.role == .professor) {
            mode = .edit
        }
        segmentView = PaginationView(mode)
        self.courseViewModel = CoursesViewModel(
            CourseNetworkManager(),
            self,
            courseCollectionView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        courseCollectionView.delegate = self
    }

    // MARK: - Navbar setup
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

    // MARK: - UI setup
    private func configureUI() {
        self.view.backgroundColor = .background.style(.accent)()
        setupNavBar()

        setupSegmentView()
        setupCollectionView()
    }

    private func setupSegmentView() {
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

    public func setSegments(content: [(String, Int)]) {
        segmentView.setTitles(
            titles:
                content.map({
                    PageItem(
                        title: $0.0,
                        notifications: $0.1
                    )
                })
        )
    }

    // MARK: - Interactions
    @objc
    private func editCourseButtonPressed() {}

    // MARK: - Navigation
    private func navigateToCreateCourse() {
        let addCourse = AddEditCourseViewController()

        addCourse.modalPresentationStyle = .popover
        self.present(addCourse, animated: true)
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

// MARK: - FlowLayout Delegate
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
        let indexPath = IndexPath(row: index, section: 0)
        guard let item = courseCollectionView.cellForItem(at: indexPath) else {
            return
        }
        courseCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }

    func addItemChosen() {
        navigateToCreateCourse()
    }
}
