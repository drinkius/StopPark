//
//  InformationViewController.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {
    
    private lazy var informationView: InformationView = {
        let view = InformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeBackground
        setupView()
    }
    
    private func setupView() {
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension InfoVC {
    private func configureViews() {
        [informationView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [informationView.topAnchor.constraint(equalTo: view.topAnchor),
         informationView.leftAnchor.constraint(equalTo: view.leftAnchor),
         informationView.rightAnchor.constraint(equalTo: view.rightAnchor),
         informationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}
