//
//  Appeal.swift
//  StopPark
//
//  Created by Arman Turalin on 1/3/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

struct Appeal: Codable {
    var id: String = ""
    var code: String = ""
    let time: Double
    var url: String {
        return URLs.cheackStatusURL + code
    }
    var status: Bool = false
}
