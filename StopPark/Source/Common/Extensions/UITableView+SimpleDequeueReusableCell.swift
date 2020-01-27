//
//  UITableView+SimpleDequeueReusableCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/27/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: "\(cellClass)")
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else { fatalError() }
        return cell
    }
}
