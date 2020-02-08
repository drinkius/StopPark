//
//  UICollectionView+SimpleDequeueReusableCell.swift
//  StopPark
//
//  Created by Arman Turalin on 2/8/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: "\(cellClass)")
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as? T else { fatalError() }
        return cell
    }
}
