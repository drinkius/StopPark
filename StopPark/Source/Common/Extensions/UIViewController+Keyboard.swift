//
//  UIViewController+Keyboard.swift
//  StopPark
//
//  Created by Arman Turalin on 1/18/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenSwipeAround() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipe.cancelsTouchesInView = false
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
