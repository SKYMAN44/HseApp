//
//  CalendarExportViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import UIKit

final class CalendarExportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - UI setup
    private func setupUI() {
        setupNavBar()
        self.view.backgroundColor = .background.style(.firstLevel)()
    }

    // MARK: - NavBar setup
    private func setupNavBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Calendar Export"
        self.navigationController?.navigationBar.tintColor = .black
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "chevronleft"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem = leftBarButton
    }

    // MARK: - Navigation
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension CalendarExportViewController: UIGestureRecognizerDelegate {}
