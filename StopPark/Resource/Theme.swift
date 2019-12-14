//
//  Theme.swift
//  StopPark
//
//  Created by Arman Turalin on 12/14/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

extension CGFloat {
    static let tabBarHeight: CGFloat = 50
    static let nanoPadding: CGFloat = 6
    static let smallPadding: CGFloat = 8
    static let padding: CGFloat = 10
    static let extraPadding: CGFloat = 18
    static let hugePadding: CGFloat = 30
    static let separatorHeight: CGFloat = 1
    static let borderWidth: CGFloat = 1
    static let elementSpacing: CGFloat = 24
    static let topInset: CGFloat = 51
    static let cellHeight: CGFloat = 48
}

extension UIColor {
    static let separator: UIColor = #colorLiteral(red   : 0.9254901961, green   : 0.9098039216, blue   : 0.9098039216, alpha   : 1)
    static let highlited: UIColor = #colorLiteral(red: 0, green: 0.5388351083, blue: 0.9526227117, alpha: 1)
    
    static var nameEditingColor: UIColor = .highlited
    static var nameDefaultColor: UIColor = .darkGray
}
