//
//  BaseGroupTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class BaseGroupedTableViewCell: BaseTableViewCell {
    
    public var destination: Destination = .middle {
        didSet { updateConfiguredConstraints() }
    }
    
    var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .themeContainer
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension BaseGroupedTableViewCell {
    private func configureViews() {
        [contentContainer].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0),
         contentContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: .padding),
         contentContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -.padding),
         contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ].forEach { $0.isActive = true }
    }
    
    private func updateConfiguredConstraints() {
        switch destination {
        case .top:
            contentContainer.roundCorners(corners: [.topLeft, .topRight], radius: .standartCornerRadius)
            configureConstraints()

            configureShadow()
        case .middle:
            contentContainer.roundCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 0)
            configureConstraints()
            configureShadow()
        case .bottom:
            contentContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: .standartCornerRadius)
            configureConstraints()

            configureShadow(height: 1)
        case .single:
            contentContainer.roundCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: .standartCornerRadius)
            configureConstraints()

            configureShadow(height: 1)
        }
    }
    
    private func configureShadow(height: Int = 0) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 1
        layer.shadowOffset = .init(width: 1, height: height)
    }
}

// MARK: - Support
extension BaseGroupedTableViewCell {
    enum Destination {
        case top
        case middle
        case bottom
        case single
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
