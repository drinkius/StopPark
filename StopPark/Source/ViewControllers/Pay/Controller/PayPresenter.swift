//
//  TemplatePayPresenter.swift
//  StopPark
//
//  Created by Arman Turalin on 1/19/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

struct TemplateDescribeModel {
        
    let payStringStorage: [String] = [
        Str.Pay.payMotivationText1,
        Str.Pay.payMotivationText2,
        Str.Pay.payMotivationText3,
    ]
    
    let donateStringStorage: [String] = [
        Str.Pay.donateMotivationText1,
        Str.Pay.donateMotivationText2,
        Str.Pay.donateMotivationText3]
}

struct DonateModel {
    
    let donateButtonTitlesStorage: [(UIColor, String)] = [
        (.donateHighlited, "😌\n75 ₽"),
        (.donatePurple, "☺️\n229 ₽"),
        (.donatePink, "😜\n699 ₽"),
        (.donateRed, "🤪\n7490 ₽")
    ]
}

class PayPresenter: NSObject {
    public var destination: Destination = .pay

    private let templateModel = TemplateDescribeModel()
    private let donateModel = DonateModel()
    private var isDonate: Bool {
        return destination == .donate ? true : false
    }

    var describes: [String] {
        return isDonate ? templateModel.donateStringStorage : templateModel.payStringStorage
    }
            
    var donateButtons: [(color: UIColor, text: String)] {
        return donateModel.donateButtonTitlesStorage
    }
    
    var donateButtonsIsHidden: Bool {
        return !isDonate
    }
    
    var payButtonIsHidden: Bool {
        return isDonate
    }
    
    var termsText: NSAttributedString {
        let text = NSMutableAttributedString(string: Str.Pay.terms)
        let linkText = Str.Pay.companyRulesText
        let range = text.mutableString.range(of: linkText)
        text.addAttribute(.link, value: URLs.companyRulesLink, range: range)
        return text
    }
    
    var titleText: String {
        return isDonate ? Str.Pay.titleDonate : Str.Pay.titlePay
    }
}

// MARK: - Support
extension PayPresenter {
    enum Destination {
        case donate
        case pay
    }
}
