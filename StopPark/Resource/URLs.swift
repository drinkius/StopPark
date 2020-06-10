//
//  URLs.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

struct URLs {
    private static let base = "https://xn--90adear.xn--p1ai"
    private static let mainRequest = base + "/request_main"
    private static let emailRequest = base + "/request_main/confirm_mail"
    private static let checkCode = base + "/request_main/check_code"
    private static let checkCorrect = mainRequest + "/check_correct_form?ajax=Y"
    private static let fileupload = mainRequest + "/fileupload"
    static let getSubUnit = mainRequest + "/get_subunit_list?code="
    static let cheackStatusURL = mainRequest + "/check/?status="
    static let companyRulesLink: String = "https://docs.google.com/document/d/1V135CzCRsKZjFCXUksYzJ8r2qvXr2wUZzd0shCMgTis"

    static let baseURL = URL(string: base)
    static let mainRequestURL = URL(string: mainRequest)
    static let emailRequestURL = URL(string: emailRequest)!
    static let checkEmailCodeURL = URL(string: checkCode)!
    static let checkCorrectURL = URL(string: checkCorrect)
    static let fileuploadURL = URL(string: fileupload)
}
