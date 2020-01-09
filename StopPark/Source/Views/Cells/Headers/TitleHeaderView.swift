//
//  TitleHeaderView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/27/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class TitleHeaderView: BaseCollectionReusableView {
    
    public func fill(with data: String) {
        titleLabel.text = data
    }
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .themeDarkGrayText
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension TitleHeaderView {
    private func configureViews() {
        [titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
         titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .extraPadding),
         titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -.extraPadding),
         titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension TitleHeaderView {
    static let identifier: String = "titleHeaderViewID"
}
