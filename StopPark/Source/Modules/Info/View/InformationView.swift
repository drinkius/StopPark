//
//  InformationView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class InformationView: BaseView {
    
    private var textView: UITextView = {
        let tv = UITextView()
        tv.text = Strings.informationText
        tv.allowsEditingTextAttributes = false
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension InformationView {
    private func configureViews() {
        [textView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [textView.topAnchor.constraint(equalTo: topAnchor),
         textView.leftAnchor.constraint(equalTo: leftAnchor, constant: .nanoPadding),
         textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.nanoPadding),
         textView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}
