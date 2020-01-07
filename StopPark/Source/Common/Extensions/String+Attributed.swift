//
//  String+Attributed.swift
//  StopPark
//
//  Created by Arman Turalin on 1/7/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension String {
    var attributed: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        return attributedString
    }
}

extension NSMutableAttributedString {
    func appendBold(_ text: String, withFontSize: CGFloat = 14) -> NSMutableAttributedString {
        let attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: withFontSize)]
        let boldString = NSMutableAttributedString(string: text, attributes: attribute)
        self.append(boldString)
        return self
    }
}
