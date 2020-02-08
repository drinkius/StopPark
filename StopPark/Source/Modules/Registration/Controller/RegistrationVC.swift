//
//  RegistrationVC.swift
//  StopPark
//
//  Created by Arman Turalin on 12/16/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
            
    var sections: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    public var destination: Destination = .registration {
        didSet {
            title = Str.Registration.titleProfile
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl = {
        let items = [RegistrationType.user.title, RegistrationType.organization.title]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.addTarget(self, action: #selector(changeForm(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
        
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .themeBackground
        tw.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tw.showsVerticalScrollIndicator = false
        [TextFieldCell.self].forEach { tw.register($0) }
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
    
    private lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Готово", for: .normal)
        btn.setTitleColor(.submitTitleColor, for: .normal)
        btn.backgroundColor = .submitBackgroundColor
        btn.layer.cornerRadius = .standartCornerRadius
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        InvAnalytics.shared.sendEvent(event: .loginPageOpened)
        setupView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Private Functions
extension RegistrationVC {
    private func setupView() {
        view.backgroundColor = .themeBackground
        hideKeyboardWhenTappedAround()
        observeKeyboard()
        configureViews()
        configureConstraints()
        configureSections(for: .user)
    }

    private func configureViews() {
        [segmentedControl, tableView, submitButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .nanoPadding),
         segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .nanoPadding),
         segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         
         tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: .nanoPadding),
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor),
         
         submitButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .nanoPadding),
         submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.nanoPadding)
            ].forEach { $0.isActive = true }
    }

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    private func configureSections(for type: RegistrationType) {
        var sections: [Section] = []

        switch type {
        case .user: sections.append(Section(type: .privacy(Str.Registration.sectionPrivacy), rows: FormData.userData.map { Section.RowType.form($0)}))
        case .organization: sections.append(Section(type: .privacy(Str.Registration.sectionPrivacy), rows: FormData.orgData.map { Section.RowType.form($0)}))
        }
        sections.append(Section(type: .contacts(Str.Registration.sectionContacts), rows: FormData.contactInfo.map { Section.RowType.form($0)}))

        self.sections = sections
    }
}

// MARK: - Actions
extension RegistrationVC {
    @objc private func changeForm(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: configureSections(for: .user)
        case 1: configureSections(for: .organization)
        default: break
        }
    }
    
    @objc private func submit() {
        InvAnalytics.shared.sendEvent(event: .loginClickButton)
        view.endEditing(true)
        
        guard AuthorizationManager.authorized else {
            showErrorMessage(Str.Generic.errorNotFilled)
            InvAnalytics.shared.sendEvent(event: .loginFail)
            return
        }
        
        guard let email = UserDefaultsManager.getFormData(.userEmail), email.isEmail() else {
            showErrorMessage(Str.Generic.errorWrongEmail)
            InvAnalytics.shared.sendEvent(event: .loginFail)
            return
        }

        Vibration.success.vibrate()
        switch destination {
        case .registration:
            InvAnalytics.shared.sendEvent(event: .loginSuccess)
            
            let router = HomeRouter()
            let formVC = HomeVC(router: router)
            let nav = CustomNavigationController(rootViewController: formVC)
            router.baseViewController = nav
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        case .settings:
            dismiss(animated: true)
        }
    }
        
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let height = keyboardFrame?.height ?? 243

        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
    }
}

// MARK: - Support
extension RegistrationVC {
    enum Theme {
        static let buttonItemHeight: CGFloat = 44.0
    }
    
    enum Destination {
        case registration
        case settings
    }
    
    enum RegistrationType {
        case user
        case organization
        
        var title: String {
            switch self {
            case .user: return Str.Registration.individualEntity
            case .organization: return Str.Registration.legalEntity
            }
        }
    }
    
    struct Section {
        enum SectionType {
            case privacy(String), contacts(String)
        }
        enum RowType {
            case form(FormData)
        }
        
        let type: SectionType
        var rows: [RowType]
    }
}
