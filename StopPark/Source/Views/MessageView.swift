//
//  MessageView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/3/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class MessageView: BaseView {
    
    public func present(with title: String) {
        titleLabel.text = title
        animateView(with: .present)
    }
    
    public func dismissView() {
        animateView(with: .dismiss)
    }
        
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 12, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupView() {
        super.setupView()
        isHidden = true
        backgroundColor = .smokeWhite
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension MessageView {
    private func configureViews() {
        [titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
         titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
            ].forEach { $0.isActive = true }
    }
    
    private func animateView(with destination: Animation) {
        switch destination {
        case .present:
            alpha = 0
            isHidden = false
        case .dismiss: break
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = destination.rawValue
        }, completion: { _ in
            self.alpha = destination.rawValue
            guard destination == .dismiss else { return }
            self.isHidden = true
            self.alpha = 1
        })
    }
}

// MARK: - Support
extension MessageView {
    enum Animation: CGFloat {
        case present = 1.0
        case dismiss = 0.0
    }
}
