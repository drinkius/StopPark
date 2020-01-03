//
//  RegistrationVC.swift
//  StopPark
//
//  Created by Arman Turalin on 12/16/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
        
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Физическое лицо", "Юридическое лицо"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.addTarget(self, action: #selector(changeForm(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
        
    private var registrationForm = Form(.registrationUser)
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .smokeWhite
        tw.showsVerticalScrollIndicator = false
        tw.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
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
        setupView()
    }
}

// MARK: - Private Functions
extension RegistrationVC {
    private func setupView() {
        view.backgroundColor = .white
        title = "Регистрация"
        configureViews()
        configureConstraints()
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
}

// MARK: - Actions
extension RegistrationVC {
    @objc private func changeForm(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            registrationForm = .init(.registrationUser)
            tableView.reloadData()
        case 1:
            registrationForm = .init(.registrationOrganization)
            tableView.reloadData()
        default: break
        }
    }
    
    @objc private func submit() {
        guard AuthorizationManager.authorized else {
            showErrorMessage("Вы заполнили не все пункты.")
            return
        }
        let formVC = HomeVC()
        let nav = UINavigationController(rootViewController: formVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - UITableView
extension RegistrationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = registrationForm.data.count
        return sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = registrationForm.data[section].cells.count
        return cells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath)
        let cells = registrationForm.data[indexPath.section].cells
        if let textFieldCell = cell as? TextFieldCell {
            
            if cells.count == 1 {
                textFieldCell.destination = .single
            }

            if indexPath.row == 0 {
                textFieldCell.destination = .top
            } else if indexPath.row == cells.count - 1 {
                textFieldCell.destination = .bottom
            } else {
                textFieldCell.destination = .middle
            }
            
            let name = cells[indexPath.row].name
            textFieldCell.fill(with: name) { text in
                
                if name == .userEmail {
                    let email = text?.lowercased()
                    UserDefaultsManager.setFormData(name, data: email)
                    return
                }
                
                UserDefaultsManager.setFormData(name, data: text)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sections = registrationForm.data
        let headerView = HeaderView()
        headerView.fill(with: sections[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == registrationForm.data.count - 1 else { return UIView() }
        let messageFooterView = MessageFooterView()
        messageFooterView.fill(with: "Ваши данные используются только для отправки Ваших обращений в ГИБДД. Мы не отправляем спам и не используем Ваши данные в иных целях.")
        return messageFooterView
    }
}

// MARK: - Support
extension RegistrationVC {
    enum Theme {
        static let buttonItemHeight: CGFloat = 44.0
    }
}
