//
//  Array+Difference.swift
//  StopPark
//
//  Created by Arman Turalin on 2/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
