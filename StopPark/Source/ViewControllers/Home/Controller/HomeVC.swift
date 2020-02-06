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
    
    let router: RouterProtocol

    private lazy var settingsButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: .settings, style: .plain, target: self, action: #selector(onSettings))
        btn.tintColor = .highlited
        return btn
    }()
    
    private lazy var giftButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: .gift, style: .plain, target: self, action: #selector(onGift))
        btn.tintColor = .red
        return btn
    }()
        
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "STOPPARK"
        lbl.textColor = .themeMainTitle
        lbl.font = .systemFont(ofSize: 12, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.delegate = self
        view.backgroundColor = .themeContainer
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .themeBackground
        tw.showsVerticalScrollIndicator = false
        [RequestTableViewCell.self].forEach { tw.register($0) }
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
        InvAnalytics.shared.sendEvent(event: .appOpens)
        UserDefaultsManager.setSession(nil)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = AppealManager.shared.appeals
        configureTitle()
        profileView.updateValues()
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
extension HomeVC {
    private func setupView() {
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
        navigationItem.rightBarButtonItems = [settingsButton, giftButton]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .themeContainer
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func checkTableViewData() {
        tableView.reloadData()
        guard data.isEmpty else {
            if messageView.isHidden == false {
                messageView.dismissView()
            }
            return
        }
        messageView.present(with: "У Вас нет пока что обращений, но Вы можете подать его сейчас.")
    }
}

// MARK: - Actions
extension HomeVC {
    @objc private func onSettings() {
        InvAnalytics.shared.sendEvent(event: .homeClickSettings)
        let context = HomeRouter.RouteContext.settings
        router.enqueueRoute(with: context)
    }
    
    @objc private func onGift() {
        let context = HomeRouter.RouteContext.donate
        router.enqueueRoute(with: context)
    }
    
    private func onForm() {
        guard Reachability.isConnectedToNetwork() else {
            showErrorMessage(Strings.notConnected)
            return
        }
        InvAnalytics.shared.sendEvent(event: .homeClickForm)
        Vibration.light.vibrate()
        let context = HomeRouter.RouteContext.form
        router.enqueueRoute(with: context)
    }
}

// MARK: - UITableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.fill(with: data[indexPath.row])
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
        onForm()
    }
}

// MARK: - Support
extension HomeVC {
    enum Theme {
        static let profileItemHeight: CGFloat = 80.0
    }
}
