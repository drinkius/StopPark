//
//  String+EmailValidation.swift
//  StopPark
//
//  Created by Arman Turalin on 1/17/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
