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
    static let standartCornerRadius: CGFloat = 10.0
}

extension UIColor {
    static let separator: UIColor = #colorLiteral(red   : 0.9254901961, green   : 0.9098039216, blue   : 0.9098039216, alpha   : 1)
    static let highlited: UIColor = #colorLiteral(red: 0, green: 0.5388351083, blue: 0.9526227117, alpha: 1)
    static let smokeWhite: UIColor = #colorLiteral(red: 0.9458671212, green: 0.9460254312, blue: 0.9458462596, alpha: 1)
    static let darkSmokeWhite: UIColor = #colorLiteral(red: 0.8354733586, green: 0.8305075765, blue: 0.8392909169, alpha: 1)
    static let smokeBlack: UIColor = #colorLiteral(red: 0.109914951, green: 0.1096751764, blue: 0.1183810011, alpha: 1)
    static let lightBlack: UIColor = #colorLiteral(red: 0.1800150275, green: 0.1819972694, blue: 0.1984114647, alpha: 1)
    static let darkSmokeBlack: UIColor = #colorLiteral(red: 0.05661133677, green: 0.05660288781, blue: 0.06190235168, alpha: 1)
    
    static let donateHighlited: UIColor = #colorLiteral(red: 0, green: 0.5388351083, blue: 0.9526227117, alpha: 1)
    static let donatePurple: UIColor = #colorLiteral(red: 0.5314916372, green: 0.2076499164, blue: 0.9585089087, alpha: 1)
    static let donatePink: UIColor = #colorLiteral(red: 0.607652843, green: 0, blue: 0.5416814089, alpha: 1)
    static let donateRed: UIColor = #colorLiteral(red: 0.456125617, green: 0, blue: 0, alpha: 1)

    static var nameEditingColor: UIColor = .highlited
    static var nameDefaultColor: UIColor = .darkGray
    static var submitTitleColor: UIColor = .white
    static var submitBackgroundColor: UIColor = .highlited
    
    static let loaderDoneColor: UIColor = .highlited
    static let loaderLoadingColor: UIColor = .lightGray

    static let themeBackground: UIColor = setColor(light: smokeWhite, dark: black)
    static let themeContainer: UIColor = setColor(light: white, dark: smokeBlack)
    static let themeMainTitle: UIColor = setColor(light: black, dark: white)
    static let themePicker: UIColor = setColor(light: white, dark: black)
    static let themeGrayText: UIColor = setColor(light: gray, dark: lightGray)
    static let themeDarkGrayText: UIColor = setColor(light: darkGray, dark: gray)
    static let themeTextViewBackground: UIColor = themeContainer
    static let themeTextViewText: UIColor = themeMainTitle
    static let themeBlurBackground: UIColor = themeMainTitle
    static let themeDarkSmokeBackground: UIColor = setColor(light: darkSmokeWhite, dark: darkSmokeBlack)
    static let themeDiffrentImageTint: UIColor = setColor(light: lightGray, dark: darkGray)
    static let themeGroupCellHighlight: UIColor = setColor(light: darkSmokeWhite, dark: lightBlack)
    static let themePayText: UIColor = setColor(light: darkGray, dark: lightText)
    static let themeButtonTint: UIColor = themeMainTitle
}

extension UIImage {
    static let done     = UIImage(named: "success")?.withRenderingMode(.alwaysTemplate)
    static let send     = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
    static let delete   = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
    static let update   = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
    static let add      = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
    static let profile  = UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate)
    static let waiting  = UIImage(named: "waiting")?.withRenderingMode(.alwaysTemplate)
    static let consider = UIImage(named: "consider")?.withRenderingMode(.alwaysTemplate)
    static let lock     = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
    static let settings = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
    static let gift     = UIImage(named: "gift")?.withRenderingMode(.alwaysTemplate)
    
    static let payBackground     = UIImage(named: "payBackground")
}

extension UIEdgeInsets {
    static let buttonItemContentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
}
