//
//  LoaderView.swift
//  StopPark
//
//  Created by Arman Turalin on 2/7/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class LoaderView: BaseView {
    
    public func startAnimating() {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            self.alpha = 1.0
        })
    }
    
    public func stopAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            UIView.animate(withDuration: 0.4, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
                self.alpha = 1.0
            })
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = .standartCornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .highlited
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        super.setupView()
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        isHidden = true
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension LoaderView {
    private func configureViews() {
        [containerView].forEach { addSubview($0) }
        [indicator].forEach { containerView.addSubview($0) }
    }
    
    private func configureConstraints() {
        [containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
         containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
         containerView.heightAnchor.constraint(equalToConstant: Theme.containerItemSize.height),
         containerView.widthAnchor.constraint(equalToConstant: Theme.containerItemSize.width),
        
         indicator.topAnchor.constraint(equalTo: containerView.topAnchor),
         indicator.leftAnchor.constraint(equalTo: containerView.leftAnchor),
         indicator.rightAnchor.constraint(equalTo: containerView.rightAnchor),
         indicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension LoaderView {
    enum Theme {
        static let containerItemSize: CGSize = .init(width: 80.0, height: 80.0)
    }
}
