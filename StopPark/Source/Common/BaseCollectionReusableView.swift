//
//  BaseCollectionReusableView.swift
//  Sipaz
//
//  Created by Arman Turalin on 12/25/19.
//  Copyright © 2019 agily. All rights reserved.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
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
