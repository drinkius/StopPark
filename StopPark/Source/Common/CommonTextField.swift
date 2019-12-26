//
//  CommonTextField.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

public struct ReturnKeyAction {
    let button: UIReturnKeyType
    let block: (String) -> Void
}

class CommonTextField: BaseView {
        
    public var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    public var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    public var returnKeyAction: ReturnKeyAction? {
        didSet {
            if let action = returnKeyAction {
                textField.returnKeyType = action.button
            }
        }
    }
    
    public var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
        
    private var containerStack: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .nameDefaultColor
//        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func setupView() {
        super.setupView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activateResponder)))
        
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension CommonTextField {
    private func configureViews() {
        [containerStack].forEach {
            addSubview($0)
        }
        [nameLabel, textField].forEach {
            containerStack.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        [containerStack.topAnchor.constraint(equalTo: topAnchor),
         containerStack.leftAnchor.constraint(equalTo: leftAnchor),
         containerStack.rightAnchor.constraint(equalTo: rightAnchor),
         containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
         
         nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Display.width / 2)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension CommonTextField {
    @objc private func activateResponder() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension CommonTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        returnKeyAction?.block(text)
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.nameLabel.textColor = .nameEditingColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        returnKeyAction?.block(text)
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.2) {
            self.nameLabel.textColor = .nameDefaultColor
        }
    }
}

// MARK: - Theme
extension CommonTextField {
    enum Theme {
        static let textFieldItemWidthMinimum: CGFloat = 50.0
        static let nameLabelItemWidthMinimun: CGFloat = 50.0
    }
}
