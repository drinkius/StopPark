//
//  ProfileVC.swift
//  StopPark
//
//  Created by Arman Turalin on 1/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
        
    var sections: [Section] {
        return [
            Section(type: .privacy, rows: [.privacy]),
            Section(type: .additional, rows: [.setting])
        ]
    }
    
    let router: RouterProtocol!
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .clear
        [ProfileTableViewCell.self, SettingCell.self].forEach { tw.register($0) }
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
    
    init(router: RouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
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
        title = Str.Settings.title
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeContainer
    }
}

// MARK: - Support
extension SettingsVC {
    struct Section {
        enum SectionType {
            case privacy, additional
            
            var title: String {
                switch self {
                case .privacy: return Str.Settings.sectionProfile
                case .additional: return Str.Settings.sectionAdditional
                }
            }
        }
        enum RowType {
            case privacy
            case setting
            
            var title: String {
                switch self {
                case .privacy: return Str.Settings.rowPrivacy
                case .setting: return Str.Settings.rowInfo
                }
            }
        }
        
        let type: SectionType
        var rows: [RowType]
    }
}
