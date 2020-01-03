//
//  TextFieldCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class TextFieldCell: BaseGroupedTableViewCell {
    
    public func fill(with data: FormData, block: @escaping (String?) -> ()) {
        titleLabel.text = data.rawValue
        actionBlock = block
        
        switch data {
        case .userPhone, .userOrganizationNumber, .userOrganizationLetter:
            textField.keyboardType = .numberPad
        case .userEmail:
            textField.keyboardType = .emailAddress
        default: textField.keyboardType = .default
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        switch selected {
        case true: textField.becomeFirstResponder()
        case false: textField.resignFirstResponder()
        }
    }
                       
    private var titleLabelTopConstraint: NSLayoutConstraint!
    private var titleLabelBottomConstraint: NSLayoutConstraint!
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Value"
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var actionBlock: ((String?) -> ())?
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.returnKeyType = .done
        tf.font = .systemFont(ofSize: 12)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        super.setupView()
        backgroundColor = .clear
        selectionStyle = .none
        configureViews()
        configureConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.resignFirstResponder()
    }
}

// MARK: - Private Functions
extension TextFieldCell {
    private func configureViews() {
        [titleLabel, textField, separatorView].forEach {
            contentContainer.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .extraPadding)
        titleLabelBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        
        [titleLabelTopConstraint,
         titleLabel.leftAnchor.constraint(equalTo: textField.leftAnchor),
         titleLabel.rightAnchor.constraint(equalTo: textField.rightAnchor),
         titleLabelBottomConstraint,
         
         textField.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .extraPadding),
         textField.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .hugePadding),
         textField.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.hugePadding),
         textField.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -.nanoPadding),
        
         separatorView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.nanoPadding),
         separatorView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .extraPadding),
         separatorView.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.extraPadding),
         separatorView.heightAnchor.constraint(equalToConstant: .separatorHeight)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension TextFieldCell {
    private func animateTextCell() {
        if textField.text?.isEmpty == false || textField.isFirstResponder {
            titleLabelTopConstraint.constant = .zero
            titleLabelBottomConstraint.constant = -.extraPadding
        } else {
            titleLabelTopConstraint.constant = .extraPadding
            titleLabelBottomConstraint.constant = .zero
        }
                
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
            if self.textField.isFirstResponder {
                self.separatorView.backgroundColor = .blue
            } else {
                self.separatorView.backgroundColor = .lightGray
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionBlock?(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextCell()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        actionBlock?(textField.text)
        animateTextCell()
    }
}

// MARK: - Support
extension TextFieldCell {
    static let identifier: String = "textFieldCellID"
}
