//
//  UIColor+TraitCollection.swift
//  StopPark
//
//  Created by Arman Turalin on 1/8/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension UIColor {
    static func setColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor {
                $0.userInterfaceStyle == .dark ? dark : light
            }
        }
        return light
    }
}
