//
//  BaseTableVIewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
    }
}
