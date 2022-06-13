//
//  CalendarExportViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import UIKit

final class CalendarExportViewController: UIViewController {
    private let exportManager = CalendarExportService.shared

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let titleLabel = UILabel()
    private let optionCell = UITableViewCell()
    private let sliderCell = UITableViewCell()
    private let exportCell = UITableViewCell()
    private let optionLabel = UILabel()
    private let exportButton = PrimaryButton()
    private let slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .primary.style(.primary)()
        slider.addTarget(self, action: #selector(incomeSliderChanged(_:)), for: .valueChanged)
        slider.minimumValue = 1
        slider.maximumValue = 6

        return slider
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isScrollEnabled = false
        tableView.dataSource = self

        setupUI()
    }

    // MARK: - UI setup
    private func setupUI() {
        setupNavBar()
        setupCells()

        self.view.backgroundColor = .background.style(.firstLevel)()

        tableView.allowsSelection = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.rowHeight = 60

        view.addSubview(tableView)
        tableView.pin(to: view)

        exportButton.addTarget(self, action: #selector(exportButtonPressed(_:)), for: .touchUpInside)
    }

    private func setupCells() {
        titleLabel.text = "Export Assigmnets"
        titleLabel.textAlignment = .left
        titleLabel.font = .customFont.style(.caption)()
        titleLabel.textColor = .textAndIcons.style(.secondary)()

        optionLabel.text = "1 week ahead"
        optionLabel.textAlignment = .left
        optionLabel.font = .customFont.style(.headline)()
        optionCell.selectionStyle = .none

        let stackView = UIStackView(arrangedSubviews: [titleLabel, optionLabel])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical

        optionCell.contentView.addSubview(stackView)
        stackView.pin(to: optionCell, [.left: 12, .right: 12, .bottom: 0])
        optionCell.backgroundColor = .background.style(.accent)()

        sliderCell.selectionStyle = .none
        sliderCell.contentView.addSubview(slider)
        sliderCell.backgroundColor = .background.style(.accent)()

        slider.pin(to: sliderCell, [.left: 12, .right: 12])
        slider.pinCenter(to: sliderCell.centerYAnchor)

        exportButton.setColors(.primary.style(.filler)(), .primary.style(.primary)())
        exportButton.setTitle("Export", for: .normal)
        exportCell.selectionStyle = .none
        exportCell.backgroundColor = .background.style(.accent)()
        exportCell.contentView.addSubview(exportButton)
        exportButton.pin(to: exportCell, [.right: 12, .left: 12, .top: 0, .bottom: 12])
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

    // MARK: - Interactions
    @objc
    private func incomeSliderChanged(_ sender: UISlider) {
        let step: Float = 1.0
        let roundedStepValue = round(sender.value / step) * step
        sender.value = Float(roundedStepValue) // remove this if you don't want discrete slider.
        optionLabel.text = Int(roundedStepValue) == 1 ?
        ("\(Int(roundedStepValue)) week ahead") : ("\(Int(roundedStepValue)) weeks ahead")
    }

    @objc
    private func exportButtonPressed(_ sender: UIButton) {
        // add fetching of events for specified date range
        exportManager.saveEvents()
    }

    // MARK: - Navigation
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension CalendarExportViewController: UIGestureRecognizerDelegate {}

// MARK: - TableDataSoure
extension CalendarExportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return optionCell
        case 1:
            return sliderCell
        default:
            return exportCell
        }
    }
}
