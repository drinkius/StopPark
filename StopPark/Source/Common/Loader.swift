//
//  Loader.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

enum LoaderStatus {
    case loading
    case done
}

class Loader: BaseView {
    
    public var status: LoaderStatus = .loading {
        didSet { updateIfNeeded() }
    }
        
    private var activity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var statusLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Загружаем"
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private var image: UIImageView = {
        let view = UIImageView()
        view.image = .done
        view.contentMode = .scaleAspectFill
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func setupView() {
        super.setupView()
        activity.startAnimating()
        layer.cornerRadius = Theme.containerItemCornerRadius
        backgroundColor = .loaderLoadingColor
        
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension Loader {
    private func configureViews() {
        [statusLabel, activity, image].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [heightAnchor.constraint(equalToConstant: Theme.containerItemHeight),
         widthAnchor.constraint(greaterThanOrEqualToConstant: Theme.containerItemWidth),
        
         statusLabel.topAnchor.constraint(equalTo: topAnchor, constant: .nanoPadding),
         statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: .smallPadding),
         statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),
        
         activity.topAnchor.constraint(equalTo: topAnchor, constant: .nanoPadding),
         activity.leftAnchor.constraint(equalTo: statusLabel.rightAnchor, constant: .padding),
         activity.rightAnchor.constraint(equalTo: rightAnchor, constant: -.nanoPadding),
         activity.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),
         
         image.topAnchor.constraint(equalTo: activity.topAnchor),
         image.leftAnchor.constraint(equalTo: activity.leftAnchor),
         image.rightAnchor.constraint(equalTo: activity.rightAnchor),
         image.bottomAnchor.constraint(equalTo: activity.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension Loader {
    private func updateIfNeeded() {
        switch status {
        case .loading:
            statusLabel.text = "Загружаем"
            activity.startAnimating()
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = .loaderLoadingColor
                self.image.alpha = 0
            }
        case .done:
            statusLabel.text = "Загружено"
            activity.stopAnimating()
            image.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = .loaderDoneColor
                self.image.transform = .identity
                self.image.alpha = 1
            }
        }
    }
}

// MARK: - Theme
extension Loader {
    enum Theme {
        static let containerItemHeight: CGFloat = 30.0
        static let containerItemWidth: CGFloat = 120.0
        
        static let containerItemCornerRadius: CGFloat = containerItemHeight / 2
    }
}
