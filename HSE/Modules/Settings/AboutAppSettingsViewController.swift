//
//  AboutAppSettingsViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.06.2022.
//

import UIKit

final class AboutAppSettingsViewController: UIViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .background.style(.firstLevel)()
        setupNavbar()
    }

    // MARK: - NavBarSetup
    private func setupNavbar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "About"
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

// MARK: - GestureDelegate
extension AboutAppSettingsViewController: UIGestureRecognizerDelegate { }
