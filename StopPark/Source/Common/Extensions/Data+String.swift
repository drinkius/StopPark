//
//  Data+String.swift
//  StopPark
//
//  Created by Arman Turalin on 1/7/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
