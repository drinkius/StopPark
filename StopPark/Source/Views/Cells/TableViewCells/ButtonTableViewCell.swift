//
//  ButtonTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/2/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func cell(_ cell: ButtonTableViewCell, buttonTouchUpInside button: UIButton)
}

class ButtonTableViewCell: BaseTableViewCell {
    
    public weak var delegate: ButtonTableViewCellDelegate?
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle(Str.Form.sendForm, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.backgroundColor = .highlited
        btn.layer.cornerRadius = .standartCornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(sendForm(_:)), for: .touchUpInside)
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
    @objc private func sendForm(_ sender: UIButton) {
        delegate?.cell(self, buttonTouchUpInside: sender)
    }
}
