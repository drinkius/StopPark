//
//  UIViewController+Alert.swift
//  FirebaseConnect
//
//  Created by Arman Turalin on 12/23/19.
//  Copyright © 2019 agily. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorMessage(_ message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    func showMessage(_ message: String, addAction actions: [UIAlertAction]) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
}
