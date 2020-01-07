//
//  Double+CalendarDate.swift
//  StopPark
//
//  Created by Arman Turalin on 1/7/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

extension Double {
    func toCalendarDate(dateFormat: String = "DD.MM.YYYY") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let time = formatter.string(from: Date(timeIntervalSince1970: self))
        return time
    }
}
