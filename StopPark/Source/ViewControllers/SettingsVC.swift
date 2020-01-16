//
//  ProfileVC.swift
//  StopPark
//
//  Created by Arman Turalin on 1/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

struct SettingSection {
    let name: String
    let cells: [String]
}

class SettingsVC: UIViewController {
    
    private var settingsData: [SettingSection] = [SettingSection(name: "Ваш профиль", cells: ["Профиль"]),
                                                SettingSection(name: "Дополнительное", cells: ["Информация о подачи заявления"])]
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .clear
        tw.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tw.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCellID")
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()
        tableView.reloadData()
    }
}

// MARK: - Private Functions
extension SettingsVC {
    private func setupView() {
        view.backgroundColor = .themeBackground

        configureViews()
        configureConstraints()
        configureDataSource()
    }
    
    private func configureViews() {
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    private func configureDataSource() {
    }
    
    private func configureTitle() {
        title = "Настройки"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeContainer
    }
}

// MARK: - UITableView
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath)
            if let profileCell = cell as? ProfileTableViewCell {
                profileCell.updateValues()
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableViewCellID")
            cell.textLabel?.text = settingsData[indexPath.section].cells[indexPath.row]
            cell.textLabel?.font = .systemFont(ofSize: 14)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.fill(with: settingsData[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == settingsData.count - 1 else { return UIView() }
        let footerView = MessageFooterView()
        let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
        footerView.fill(with: "Версия приложения: \(appVersion)")
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            InvAnalytics.shared.sendEvent(event: .settingsClickChangeProfile)
            let registrationVC = RegistrationVC()
            registrationVC.destination = .settings
            registrationVC.title = settingsData[indexPath.section].name
            let nav = CustomNavigationController(rootViewController: registrationVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } else if indexPath.section == 1 {
            InvAnalytics.shared.sendEvent(event: .settingsClickInfo)
            let infoVC = InfoVC()
            infoVC.title = "Информация"
            navigationController?.pushViewController(infoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
