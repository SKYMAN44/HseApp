//
//  SettingsViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 04.06.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .background.style(.firstLevel)()
        self.view.addSubview(exitButton)
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.pin(to: view, [.left: 24, .right: 24])
        exitButton.pinCenter(to: view.centerYAnchor)
    }
    
    @objc
    private func exitButtonTapped() {
        KeychainHelper.shared.delete(service: "HSESOCIAL", account: "account")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window!.rootViewController = LoginViewController()
        }
    }
}
