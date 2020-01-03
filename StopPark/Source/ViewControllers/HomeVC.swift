//
//  HomeVC.swift
//  StopPark
//
//  Created by Arman Turalin on 1/3/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    
    private var data: [Appeal] = [] {
        didSet { checkTableViewData() }
    }

    private lazy var profileButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: .profile, style: .plain, target: self, action: #selector(presentProfileVC))
        btn.tintColor = .highlited
        return btn
    }()
        
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "STOPPARK"
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 12, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .smokeWhite
        tw.showsVerticalScrollIndicator = false
        tw.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.identifier)
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private Functions
extension HomeVC {
    private func setupView() {
        configureTitle()
        configureViews()
        configureConstraints()
        checkTableViewData()
    }
    
    private func configureViews() {
        [profileView, tableView, messageView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         profileView.leftAnchor.constraint(equalTo: view.leftAnchor),
         profileView.rightAnchor.constraint(equalTo: view.rightAnchor),
         profileView.heightAnchor.constraint(equalToConstant: Theme.profileItemHeight),
         
         tableView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         messageView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
         messageView.leftAnchor.constraint(equalTo: view.leftAnchor),
         messageView.rightAnchor.constraint(equalTo: view.rightAnchor),
         messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    private func configureTitle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = profileButton
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func checkTableViewData() {
        guard data.isEmpty else { return }
        messageView.present(with: "У Вас нет пока что обращений, но Вы можете подать его сейчас.")
    }
}

// MARK: - Actions
extension HomeVC {
    @objc private func presentProfileVC() {
        
    }
    
    private func presentFormVC() {
        let formVC = FormVC()
        present(formVC, animated: true)
    }
}

// MARK: - UITableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.identifier, for: indexPath)
        if let requestCell = cell as? RequestTableViewCell {
            requestCell.fill(with: data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.fill(with: "Предыдущие обращения")
        return headerView
    }
}

// MARK: - ProfileViewDelegate
extension HomeVC: ProfileViewDelegate {
    func openForm() {
        presentFormVC()
    }
}

// MARK: - Support
extension HomeVC {
    enum Theme {
        static let profileItemHeight: CGFloat = 80.0
    }
}
