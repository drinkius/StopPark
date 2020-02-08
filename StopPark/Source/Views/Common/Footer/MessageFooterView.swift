//
//  MessageTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/4/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class MessageFooterView: BaseView {
    
    public func fill(with data: String) {
        messageLabel.text = data
    }
    
    private var messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 10)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .lightGray
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
extension MessageFooterView {
    private func configureViews() {
        [messageLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
         messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .padding),
         messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -.padding),
         messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
}
