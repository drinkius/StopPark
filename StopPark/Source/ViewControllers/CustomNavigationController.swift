//
//  CustomNavigationController.swift
//  StopPark
//
//  Created by Arman Turalin on 1/13/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    private lazy var backButton: UIBarButtonItem = {
        let btn = UIButton()
        btn.setTitle("Назад", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .highlited
        btn.contentEdgeInsets = .buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Actions
extension CustomNavigationController {
    @objc private func close() {
        popViewController(animated: true)
    }
}

// MARK: - Support
extension CustomNavigationController {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
    }
}
