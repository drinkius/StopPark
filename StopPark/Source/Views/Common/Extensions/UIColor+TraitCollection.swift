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
            return UIColor { trait -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return dark
                }
                return light
            }
        }
        return light
    }
}
