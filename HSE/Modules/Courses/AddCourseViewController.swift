//
//  AddCourseViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.06.2022.
//

import UIKit

final class AddCourseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - UI setup
    private func setupUI() {
        self.view.backgroundColor = .background.style(.firstLevel)()
    }
}
