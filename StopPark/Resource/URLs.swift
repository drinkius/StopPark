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
    private static let checkCorrect = mainRequest + "/check_correct_form?ajax=Y"
    private static let fileupload = mainRequest + "/fileupload"
    
    static let baseURL = URL(string: base)
    static let mainRequestURL = URL(string: mainRequest)
    static let checkCorrectURL = URL(string: checkCorrect)
    static let fileuploadURL = URL(string: fileupload)
}