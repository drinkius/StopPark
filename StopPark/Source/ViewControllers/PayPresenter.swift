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
        "Получаете безлимитный доступ к темплейтам, которые повысят шанс положительного исхода вашего заявления!",
        "Экономите время при заполнении формы!",
        "Поддерживаете разработку проекта и разработчиков данного проекта!",
    ]
    
    let donateStringStorage: [String] = [
        "Улучшаете город вместе с нами!",
        "Становитесь частью сообщества, которому не все равно на город и общественность!",
        "Поддерживаете разработку проекта и разработчиков данного проекта!"]
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
        let text = NSMutableAttributedString(string: "При выборе подписки сумма будет списана с учетной записи iTunes при подтверждении покупки.\nПользователь может управлять подписками, а автоматическое продление может быть отключено в настройках учетной записи пользователя после покупки.\nПодписка автоматически продлевается, если автоматическое продление не отключено по крайней мере за 24 часа до окончания текущего периода.\nПравила компании вы можете прочитать тут")
        let linkText = "Правила компании вы можете прочитать тут"
        let range = text.mutableString.range(of: linkText)
        text.addAttribute(.link, value: "https://www.google.com", range: range)
        return text
    }
    
    var titleText: String {
        return isDonate ? "ПОДДЕРЖКА\nРАЗРАБОТЧИКОВ" : "ПРЕМИУМ\nДОСТУП"
    }
}

// MARK: - Support
extension PayPresenter {
    enum Destination {
        case donate
        case pay
    }
}
