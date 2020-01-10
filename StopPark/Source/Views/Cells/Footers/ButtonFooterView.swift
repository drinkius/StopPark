//
//  ButtonFooterView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/10/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class ButtonFooterView: BaseView {
    
    public func fill(buttonName name: String, action: (() -> Void)? ) {
        button.setTitle(name, for: .normal)
        actionBlock = action
    }
    
    private var actionBlock: (() -> Void)?
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.highlited, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.titleLabel?.numberOfLines = 2
        btn.addTarget(self, action: #selector(onButtonClicked(_:)), for: .touchUpInside)
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
extension ButtonFooterView {
    private func configureViews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [button.topAnchor.constraint(equalTo: topAnchor),
         button.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         button.centerYAnchor.constraint(equalTo: centerYAnchor),
         button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension ButtonFooterView {
    @objc private func onButtonClicked(_ sender: UIButton) {
        actionBlock?()
    }
}
