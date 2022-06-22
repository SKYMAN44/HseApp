//
//  AddCourseViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.06.2022.
//

import UIKit

final class AddEditCourseViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let courseNameTextField = UITextField()
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let formulaTitleLabel = UILabel()
    private let formulaTextView = UITextView()
    private let createButton = PrimaryButton()
    private var activityAnimation = ActivityAnimationScreen(
        colors: [.primary.style(.primary)(), .primary.style(.filler)()],
        lineWidth: 5
    )
    private var isAnimating: Bool = false {
        didSet {
            if(isAnimating) {
                activityAnimation.isHidden = false
                activityAnimation.isAnimating = true
            } else {
                activityAnimation.isHidden = true
                activityAnimation.isAnimating = false
            }
        }
    }

    private var netWorkManager: SubjectsNetworkManager?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        view.addGestureRecognizer(tap)

        netWorkManager = CourseNetworkManager()
        setupUI()
    }

    // MARK: - UI setup
    private func setupUI() {
        setupActivityAnimation()
        self.view.backgroundColor = .background.style(.firstLevel)()

        self.view.addSubview(scrollView)
        scrollView.pin(to: view, [.left: 16, .right: 16, .top: 28, .bottom: 0])

        setupTextField()
        let descSV = setupDescription()
        let formSV = setupFormula()
        let stackView = UIStackView(arrangedSubviews: [courseNameTextField, descSV, formSV])
        stackView.spacing = 16
        stackView.axis = .vertical

        scrollView.addSubview(stackView)
        stackView.pinWidth(to: scrollView.widthAnchor)
        stackView.pinTop(to: scrollView.topAnchor)

        setupButton()
    }

    private func setupTextField() {
        courseNameTextField.font = .customFont.style(.headline)()
        courseNameTextField.borderStyle = .none
        courseNameTextField.autocorrectionType = .no
        courseNameTextField.spellCheckingType = .no
        courseNameTextField.placeholder = "Enter course name"
    }

    private func setupDescription() -> UIStackView{
        descriptionTitleLabel.text = "Course Description"
        descriptionTitleLabel.font = .customFont.style(.body)()

        descriptionTextView.isScrollEnabled = false
        descriptionTextView.layer.borderWidth = 0
        descriptionTextView.clipsToBounds = true
        descriptionTextView.delegate = self
        descriptionTextView.textColor = .textAndIcons.style(.tretiary)()
        descriptionTextView.font = .customFont.style(.body)()
        descriptionTextView.text = "Type to add description"

        let stackView = UIStackView(arrangedSubviews: [descriptionTitleLabel, descriptionTextView])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }

    private func setupFormula() -> UIStackView {
        formulaTitleLabel.text = "Course formula"
        formulaTitleLabel.font = .customFont.style(.body)()

        formulaTextView.isScrollEnabled = false
        formulaTextView.layer.cornerRadius = 8
        formulaTextView.backgroundColor = .background.style(.accent)()
        formulaTextView.layer.borderWidth = 0
        formulaTextView.clipsToBounds = true
        formulaTextView.delegate = self
        formulaTextView.textColor = .textAndIcons.style(.tretiary)()
        formulaTextView.font = .customFont.style(.body)()
        formulaTextView.text = "//add formula"

        let stackView = UIStackView(arrangedSubviews: [formulaTitleLabel, formulaTextView])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }

    private func setupButton() {
        createButton.setColors(.background.style(.accent)(), .textAndIcons.style(.primary)())
        createButton.setTitle("Publish", for: .normal)
        createButton.addTarget(self, action: #selector(createCourseButtonPressed), for: .touchUpInside)

        self.view.addSubview(createButton)
        createButton.pin(to: view, [.bottom: 28, .left: 16, .right: 16])
    }

    // MARK: - Loading Animation
    private func setupActivityAnimation() {
        self.view.addSubview(activityAnimation)
        activityAnimation.pin(to: view)
        activityAnimation.isHidden = true
    }

    // MARK: - Interactions
    @objc
    private func createCourseButtonPressed() {
        self.isAnimating = true
        guard let name = courseNameTextField.text,
              let desc = descriptionTextView.text
        else {
            return
        }
        let course = CourseCreation(courseName: name, courseDescription: desc)
        netWorkManager?.createCourse(course) { data, error in
            if let error = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.isAnimating = false
                    let alert = UIAlertController(title: "Failed to add Course", message: error , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.isAnimating = false
                    self.dismiss(animated: true)
                }
            }
        }
    }

    @objc
    private func didTapScreen() {
        courseNameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        formulaTextView.resignFirstResponder()
    }
}

// MARK: - TextView Delegate
extension AddEditCourseViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == descriptionTextView) {
            if textView.textColor == .textAndIcons.style(.tretiary)() {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        } else {
            if textView.textColor == .textAndIcons.style(.tretiary)() {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == descriptionTextView)  {
            if textView.text == "" {
                textView.text = "Type to add description"
                textView.textColor = .textAndIcons.style(.tretiary)()
            }
        } else {
            if textView.text == "" {
                textView.text = "/// add formula"
                textView.textColor = .textAndIcons.style(.tretiary)()
            }
        }
    }
}
