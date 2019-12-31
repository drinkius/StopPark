//
//  LoadImageCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class LoadImageCell: BaseCollectionViewCell {
        
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hintLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Нажмите, чтобы выбрать изображение"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

extension LoadImageCell {
    private func configureViews() {
        [containerView, hintLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [containerView.topAnchor.constraint(equalTo: topAnchor, constant: .smallPadding),
         containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: .smallPadding),
         containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.smallPadding),
         containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.smallPadding),
         
         hintLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
         hintLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         hintLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .hugePadding),
         hintLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.hugePadding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension LoadImageCell {
    static let identifier: String = "loadImageCEllId"
}
