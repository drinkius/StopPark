//
//  LoadImageCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setImage(.add, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .blue
        btn.isUserInteractionEnabled = false
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

extension ButtonCollectionViewCell {
    private func configureViews() {
        [button].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [button.topAnchor.constraint(equalTo: topAnchor, constant: .smallPadding),
         button.leftAnchor.constraint(equalTo: leftAnchor, constant: .smallPadding),
         button.rightAnchor.constraint(equalTo: rightAnchor, constant: -.smallPadding),
         button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.smallPadding),
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension ButtonCollectionViewCell {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
    }
    static let identifier: String = "loadImageCEllId"
}
