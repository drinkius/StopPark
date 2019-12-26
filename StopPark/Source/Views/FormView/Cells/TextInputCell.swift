//
//  TextInputCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class TextInputCell: BaseTableViewCell {
    
    public func fill(with model: Cell) {
        textField.name = model.name.rawValue
        textField.returnKeyAction = ReturnKeyAction(button: .done, block: model.name.formDataAction())
        switch model.name {
        case .userEmail:
            textField.keyboardType = .emailAddress
        case .userPhone, .userNumberLetter, .userNumber:
            textField.keyboardType = .numberPad
        default: textField.keyboardType = .default
        }
        configureFetchingData(at: model.name)
    }
    
    private var textField: CommonTextField = {
        let view = CommonTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
        
    override func setupView() {
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension TextInputCell {
    private func configureViews() {
        [textField, separator].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [textField.topAnchor.constraint(equalTo: topAnchor, constant: .nanoPadding),
         textField.leftAnchor.constraint(equalTo: leftAnchor, constant: .nanoPadding),
         textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -.nanoPadding),
         textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),
         
         separator.heightAnchor.constraint(equalToConstant: .separatorHeight),
         separator.leftAnchor.constraint(equalTo: leftAnchor),
         separator.rightAnchor.constraint(equalTo: rightAnchor),
         separator.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

extension TextInputCell {
    private func configureFetchingData(at type: FormData) {
        textField.returnKeyAction = ReturnKeyAction(button: .done) { text in
            switch type {
            case .userName: UserDefaultsManager.setUserName(text)
            case .userSurname: UserDefaultsManager.setUserSurname(text)
            case .userFatherName: UserDefaultsManager.setUserFatherName(text)
            case .userEmail: UserDefaultsManager.setEmail(text)
            case .userPhone: UserDefaultsManager.setPhone(text)
            default: break
            }
        }
    }
}

// MARK: - Support
extension TextInputCell {
    static let identifier: String = "textInputCellId"
}
