//
//  InformationView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol InformationViewDelegate: class {
    func submit()
}

class InformationView: BaseView {
    
    public weak var delegate: InformationViewDelegate?
    
    private var textView: UITextView = {
        let tv = UITextView()
        tv.text = Strings.informationText
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("С информацией ознакомлен", for: .normal)
        btn.setTitleColor(.submitTitleColor, for: .normal)
        btn.backgroundColor = .submitBackgroundColor
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        [textView, submitButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [textView.topAnchor.constraint(equalTo: topAnchor),
         textView.leftAnchor.constraint(equalTo: leftAnchor),
         textView.rightAnchor.constraint(equalTo: rightAnchor),
         
         submitButton.topAnchor.constraint(equalTo: textView.bottomAnchor),
         submitButton.leftAnchor.constraint(equalTo: leftAnchor),
         submitButton.rightAnchor.constraint(equalTo: rightAnchor),
         submitButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension InformationView {
    @objc private func submit() {
        delegate?.submit()
    }
}
