//
//  ProfileTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: BaseGroupedTableViewCell {
    
    public func updateValues() {
        configureTitles()
    }
    
    private var profileView: UIImageView = {
        let im = UIImageView()
        im.image = .profile
        im.tintColor = .highlited
        im.contentMode = .scaleAspectFill
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    private var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Surname Name"
        lbl.textColor = .themeMainTitle
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var actionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Нажмите, чтобы изменить данные"
        lbl.textColor = .themeGrayText
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 10)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupView() {
        super.setupView()
        destination = .single
        configureViews()
        configureConstraints()
        configureTitles()
    }
}

// MARK: - Private functions
extension ProfileTableViewCell {
    private func configureViews() {
        [profileView, labelStack].forEach {
            addSubview($0)
        }
        [nameLabel, actionLabel].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        [profileView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .padding),
         profileView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .padding),
         profileView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.padding),
         profileView.widthAnchor.constraint(equalToConstant: Theme.imageViewItemWidth),
         
         labelStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .padding),
         labelStack.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: .nanoPadding),
         labelStack.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.padding),
         labelStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
    
    private func configureTitles() {
        guard let name = UserDefaultsManager.getFormData(.userName) else { return }
        guard let surname = UserDefaultsManager.getFormData(.userSurname) else { return }
        
        nameLabel.text = name + " " + surname
    }
}

// MARK: - Support
extension ProfileTableViewCell {
    enum Theme {
        static let imageViewItemWidth: CGFloat = 40.0
    }
}
