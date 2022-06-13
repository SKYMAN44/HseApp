//
//  SettingsViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 04.06.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var notificationCell: UITableViewCell = UITableViewCell()
    private var exportCell: UITableViewCell = UITableViewCell()
    private var aboutCell: UITableViewCell = UITableViewCell()
    private var exitCell: UITableViewCell = UITableViewCell()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self

        setupNavbar()
        setupUI()
    }

    // MARK: - UI setup
    private func setupUI() {
        self.view.backgroundColor = .background.style(.firstLevel)()

        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.pin(to: view)
        tableView.rowHeight = 48

        let appDetails = AppInfo(logo: UIImage(named: "testPic.jpg")!, "HSE APP (Version 1.0.0)", "Made by DSBA Student")
        view.addSubview(appDetails)

//        appDetails.setHeight(to: 175)
        appDetails.pinBottom(to: view.bottomAnchor, 116)
        appDetails.pinCenter(to: view.centerXAnchor)

        setupCells()
    }

    // decieded to make a static defult tableView
    private func setupCells() {
        notificationCell.accessoryType = .disclosureIndicator
        notificationCell.textLabel?.text = "Notifications"
        notificationCell.imageView?.image = UIImage(named: "bell")
        notificationCell.tintColor = .textAndIcons.style(.secondary)()
        notificationCell.backgroundColor = .background.style(.accent)()
        notificationCell.selectionStyle = .none

        exportCell.textLabel?.text = "Export to calendar"
        exportCell.accessoryType = .disclosureIndicator
        exportCell.imageView?.image = UIImage(named: "download-cloud")
        exportCell.tintColor = .textAndIcons.style(.secondary)()
        exportCell.backgroundColor = .background.style(.accent)()
        exportCell.selectionStyle = .none

        aboutCell.textLabel?.text = "About App"
        aboutCell.accessoryType = .disclosureIndicator
        aboutCell.imageView?.image = UIImage(named: "info")
        aboutCell.tintColor = .textAndIcons.style(.secondary)()
        aboutCell.backgroundColor = .background.style(.accent)()
        aboutCell.selectionStyle = .none

        exitCell.textLabel?.text = "Exit"
        exitCell.textLabel?.textColor = .special.style(.warning)()
        exitCell.imageView?.image = UIImage(named: "log-out")
        exitCell.tintColor = .special.style(.warning)()
        exitCell.backgroundColor = .background.style(.accent)()
        exitCell.selectionStyle = .none
    }

    // MARK: - NavBarSetup
    private func setupNavbar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.tintColor = .black
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "chevronleft"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem = leftBarButton
    }

    // MARK: - Interactions
    private func exitButtonTapped() {
        KeychainHelper.shared.delete(service: KeychainHelper.defaultService, account: KeychainHelper.defaultAccount)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window!.rootViewController = LoginViewController()
        }
    }

    // MARK: - Navigation
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    private func navigateTo(_ viewController: UIViewController) {
        self.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - TableDataSoure
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return notificationCell
        case 1:
            return exportCell
        case 2:
            return aboutCell
        case 3:
            return exitCell
        default:
            return notificationCell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            let exportVC = CalendarExportViewController()
            navigateTo(exportVC)
        case 2:
            return
        case 3:
            exitButtonTapped()
        default:
            return
        }
    }
}

// MARK: - GestureDelegate
extension SettingsViewController: UIGestureRecognizerDelegate { }
