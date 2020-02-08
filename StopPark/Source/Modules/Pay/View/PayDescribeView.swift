//
//  PayDescribeView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/19/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class PayDescribeView: BaseView {
    
    public func fill(with data: String) {
        describeLabel.text = data
    }
    
    private var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .themeContainer
        view.layer.cornerRadius = .standartCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var circleView: UIView = {
        let image = UIView()
        image.backgroundColor = .highlited
        image.layer.cornerRadius = Theme.circleItemCornerRadius
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var describeLabel: UILabel = {
        let view = UILabel()
        view.textColor = .themePayText
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.1
    }
}

// MARK: - Private Functions
extension PayDescribeView {
    private func configureViews() {
        [contentContainer].forEach {
            addSubview($0)
        }
        [circleView, describeLabel].forEach {
            contentContainer.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: .nanoPadding),
         contentContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: .nanoPadding),
         contentContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -.nanoPadding),
         contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),
         
         circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
         circleView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .padding),
         circleView.widthAnchor.constraint(equalToConstant: Theme.circleItemSize.width),
         circleView.heightAnchor.constraint(equalToConstant: Theme.circleItemSize.height),
         
         describeLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .padding),
         describeLabel.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: .padding),
         describeLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.padding),
         describeLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
}


// MARK: - Support
extension PayDescribeView {
    enum Theme {
        static let circleItemSize: CGSize = .init(width: 10.0, height: 10.0)
        static let circleItemCornerRadius: CGFloat = circleItemSize.height / 2
    }
}
