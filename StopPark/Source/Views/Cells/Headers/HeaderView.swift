//
//  HeaderView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/1/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class HeaderView: BaseView {
    
    public func fill(with title: String) {
        titleLabel.text = title
    }
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

extension HeaderView {
    private func configureViews() {
        [titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
         titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .padding),
         titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -.padding),
         titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding)
            ].forEach { $0.isActive = true }
    }
}
