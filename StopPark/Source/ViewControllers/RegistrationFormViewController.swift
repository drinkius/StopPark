//
//  RegistrationFormViewController.swift
//  StopPark
//
//  Created by Arman Turalin on 12/16/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class RegistrationFormViewController: UIViewController {
        
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Физическое лицо", "Юридическое лицо"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.addTarget(self, action: #selector(changeForm(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var formView: FormView = {
        let view = FormView()
        view.formDestination = .registrationUser
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Готово", for: .normal)
        btn.setTitleColor(.submitTitleColor, for: .normal)
        btn.backgroundColor = .submitBackgroundColor
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var openUpload: UIButton = {
        let btn = UIButton()
        btn.setTitle("Download", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.backgroundColor = .submitBackgroundColor
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.addTarget(self, action: #selector(open), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private Functions
extension RegistrationFormViewController {
    private func setupView() {
        view.backgroundColor = .white
        title = "Регистрация"
        configureViews()
        configureConstraints()
    }

    private func configureViews() {
        [segmentedControl, formView, submitButton, openUpload].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .nanoPadding),
         segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .nanoPadding),
         segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         
         formView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .nanoPadding),
         formView.leftAnchor.constraint(equalTo: view.leftAnchor),
         formView.rightAnchor.constraint(equalTo: view.rightAnchor),
         formView.bottomAnchor.constraint(equalTo: submitButton.topAnchor),
         
         submitButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .nanoPadding),
         submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.nanoPadding),
         
         openUpload.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         openUpload.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .nanoPadding),
         openUpload.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         openUpload.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -.nanoPadding)

            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension RegistrationFormViewController {
    @objc private func changeForm(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            formView.formDestination = .registrationUser
        case 1:
            formView.formDestination = .registrationOrganization
        default: break
        }
    }
    
    @objc private func submit() {
        guard AuthorizationManager.authorized else { return }
        let formVC = FormVC()
        let nav = UINavigationController(rootViewController: formVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc private func open() {
        let vc = UploadImageViewController()
        present(vc, animated: true)
    }
}

// MARK: - Support
extension RegistrationFormViewController {
    enum Theme {
        static let buttonItemHeight: CGFloat = 44.0
        static let buttonItemCornerRadius: CGFloat = 8.0
    }
}
