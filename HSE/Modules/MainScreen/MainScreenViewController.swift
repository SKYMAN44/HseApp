//
//  MainScreenViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 02.06.2022.
//

import UIKit
import HSESKIT

final class MainScreenViewController: UIViewController {
    let tempArray: [PageItem] = [
        PageItem(title: "All", notifications: 132),
        PageItem(title: "HomeWork", notifications: 0),
        PageItem(title: "Midterm", notifications: 13)]

    private var navView: DropNavigationBar = DropNavigationBar()
    private let segmentView: PaginationView = {
        let segmentView = PaginationView(frame: .zero)
        segmentView.backgroundColor = .background.style(.accent)()

        return segmentView
    }()
    private var timetableModule: TimeTableScreen
    
    // MARK: - Init
    init() {
        self.timetableModule = TimeTableViewController(true)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .background.style(.accent)()
        timetableModule.delegate = self
        setupNavBar()
        setupTimeTableModule()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - UI setup
    private func setupTimeTableModule() {
        self.addChild(timetableModule)
        guard let moduleView = timetableModule.view else { return }

        self.view.insertSubview(moduleView, belowSubview: navView)
        moduleView.pin(to: view, [.left, .right])
        moduleView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        let constraint = moduleView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, navView.closedHeight)
        constraint.identifier = "tableHeightConstraint"
    }

    // MARK: - Navbar setup
    private func setupNavBar() {
        navView.navBackgroundColor = .background.style(.accent)()
        navView.navTintColor = .textAndIcons.style(.primary)()
        navView.rightItemImage = UIImage(named: "calendarCS")

        navView.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        navView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        view.addSubview(navView)

        navView.pin(to: view, [.left, .right])
        navView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        navView.closedHeight = 60
        navView.hegihtConstraintReference = navView.setHeight(to: 60)
    }

    private func addSegmentView() {
        segmentView.setTitles(titles: tempArray)
        view.addSubview(segmentView)

        segmentView.delegate = self

        segmentView.pin(to: view, [.left, .right])
        segmentView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, navView.closedHeight)
        segmentView.setHeight(to: 56)
    }

    // MARK: - Interactions
    @objc
    private func calendarButtonTapped() {
        CalendarPopUpView().show()
    }

    @objc
    private func segmentChanged() {
        switch navView.choosenSegment {
        case 0:
            updateView(content: .timeTable)
            timetableModule.contentChanged(contentType: .timeTable)
        case 1:
            updateView(content: .assigments)
            timetableModule.contentChanged(contentType: .assigments)
        default:
            print("looks like error")
        }
    }
    
    private func updateView(content: ContentType) {
        switch content {
        case .timeTable:
            // remove segmented view
            segmentView.removeFromSuperview()
            let constraint = self.view.constraints.lazy.filter { $0.identifier == "tableHeightConstraint" }.first
            constraint?.constant = navView.closedHeight
        case .assigments:
            addSegmentView()
            // place navView on top of segmentView
            view.bringSubviewToFront(navView)
            // change top constraint of tableview so segmentView not covers it
            let constraint = self.view.constraints.lazy.filter { $0.identifier == "tableHeightConstraint" }.first
            constraint?.constant = 56 + navView.closedHeight
            view.layoutIfNeeded()
        }
    }
}

// MARK: - SegmentView Delegate
extension MainScreenViewController: PaginationViewDelegate {
    func segmentChosen(index: Int) {
        var type: DeadlineContentType = .all
        switch index {
        case 1:
            type = .hw
        case 2:
            type = .cw
        default:
            type = .all
        }
        timetableModule.deadlineContentChanged(type)
    }
}

// MARK: - TimeTableModuleScrollDelegate
extension MainScreenViewController: TimeTableViewControllerScrollDelegate {
    func didScroll(_ scrollView: UIScrollView) {
        navView.hide()
    }
}
