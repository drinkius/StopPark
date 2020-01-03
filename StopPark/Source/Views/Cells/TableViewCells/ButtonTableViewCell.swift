//
//  ButtonTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/2/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func send()
}

class ButtonTableViewCell: BaseTableViewCell {
    
    public weak var delegate: ButtonTableViewCellDelegate?
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Отправить форму", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(sendForm), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension ButtonTableViewCell {
    private func configureViews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [button.topAnchor.constraint(equalTo: topAnchor, constant: .nanoPadding),
         button.leftAnchor.constraint(equalTo: leftAnchor, constant: .nanoPadding),
         button.rightAnchor.constraint(equalTo: rightAnchor, constant: -.nanoPadding),
         button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension ButtonTableViewCell {
    @objc private func sendForm() {
        delegate?.send()
    }
}

// MARK: - Support
extension ButtonTableViewCell {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
    }
    
    static let identifier: String = "buttonTableViewCellID"
}
