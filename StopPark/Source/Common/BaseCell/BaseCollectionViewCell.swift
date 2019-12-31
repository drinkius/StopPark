//
//  BaseCollectionView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/27/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() { }
}
