//
//  ProfileView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/4/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: class {
    func openForm()
}

class ProfileView: BaseView {
    
    public weak var delegate: ProfileViewDelegate?
    
    public func updateValues() {
        configureTitles()
    }
    
    private var userLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .themeMainTitle
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 23, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .themeGrayText
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var makeRequestButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(Str.Home.sendStatement, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        btn.backgroundColor = .highlited
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(makeRequest), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
        configureTitles()
    }
}

// MARK: - Private Functions
extension ProfileView {
    private func configureViews() {
        [userLabel, emailLabel, makeRequestButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [userLabel.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
         userLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .extraPadding),
         userLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -.extraPadding),
         userLabel.bottomAnchor.constraint(equalTo: makeRequestButton.topAnchor, constant: -.padding),
        
         emailLabel.topAnchor.constraint(equalTo: makeRequestButton.topAnchor),
         emailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .extraPadding),
         emailLabel.rightAnchor.constraint(equalTo: makeRequestButton.leftAnchor, constant: -.padding),
         emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding),
        
         makeRequestButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -.padding),
         makeRequestButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding),
         makeRequestButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         makeRequestButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth)
            ].forEach { $0.isActive = true }
    }
    
    private func configureTitles() {
        guard let name = UserDefaultsManager.getFormData(.userName),
            let surname = UserDefaultsManager.getFormData(.userSurname),
            let email = UserDefaultsManager.getFormData(.userEmail) else {
                userLabel.text = Str.Home.unknownUser
                emailLabel.text = Str.Home.addEmail
            return
        }
        userLabel.text = name + " " + surname
        emailLabel.text = Str.Home.email + email
    }
}

// MARK: - Actions
extension ProfileView {
    @objc private func makeRequest() {
        delegate?.openForm()
    }
}

// MARK: - Support
extension ProfileView {
    enum Theme {
        static let buttonItemHeight: CGFloat = 25.0
        static let buttonItemWidth: CGFloat = 130.0
    }
}
