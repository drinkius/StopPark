//
//  TextFieldCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class TextFieldCell: BaseGroupedTableViewCell {
    
    public weak var pickerDelegate: (UIPickerViewDelegate & UIPickerViewDataSource)?
    public func fill(with data: FormData, block: @escaping (String?) -> ()) {
        titleLabel.text = data.rawValue
        actionBlock = block
        checkSavedData(for: data)
        placeholderText = ""
        
        switch data {
        case .userPhone:
            textField.keyboardType = .phonePad
        case .userOrganizationNumber, .userOrganizationLetter:
            textField.keyboardType = .numberPad
        case .userEmail:
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case .district:
            textField.inputView = pickerView
            textField.inputAccessoryView = toolBar
        case .autoNumber:
            textField.autocapitalizationType = .allCharacters
        case .eventAddress:
            textField.autocapitalizationType = .none
        case .eventViolation:
            placeholderText = "Парковка на тротуаре, мешал прохожим."
        default: textField.keyboardType = .default
        }
    }
    public var textFieldText: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
                
    private lazy var cancelButton: UIBarButtonItem = {
        let btn = UIButton()
        btn.setTitle("Готово", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .highlited
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(textFieldEndEditing), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private lazy var toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.sizeToFit()
        tb.backgroundColor = .themePicker
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tb.setItems([cancelButton, space], animated: false)
        return tb
    }()
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = pickerDelegate
        view.backgroundColor = .themePicker
        return view
    }()
                       
    private var titleLabelTopConstraint: NSLayoutConstraint!
    private var titleLabelBottomConstraint: NSLayoutConstraint!
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Value"
        lbl.textColor = .themeGrayText
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var placeholderText: String = ""
    private var actionBlock: ((String?) -> ())?
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.autocorrectionType = .no
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
        configureContentContainer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.resignFirstResponder()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        return
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
    
    
    private func checkSavedData(for data: FormData) {
        guard FormData.userPrivacyData.contains(data) else { return }
        guard let text = UserDefaultsManager.getFormData(data) else {
            textField.text = nil
            titleLabelTopConstraint.constant = .extraPadding
            titleLabelBottomConstraint.constant = .zero
            return
        }

        textField.text = text
        titleLabelTopConstraint.constant = .zero
        titleLabelBottomConstraint.constant = -.extraPadding
    }
    
    private func configureContentContainer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeTextFieldFirstResponder))
        contentContainer.addGestureRecognizer(tap)
    }
}

// MARK: - Actions
extension TextFieldCell {
    private func animateTextCell() {
        if textField.text?.isEmpty == false || textField.isFirstResponder {
            Vibration.light.vibrate()
            titleLabelTopConstraint.constant = .zero
            titleLabelBottomConstraint.constant = -.extraPadding
            textField.placeholder = placeholderText
        } else {
            titleLabelTopConstraint.constant = .extraPadding
            titleLabelBottomConstraint.constant = .zero
            textField.placeholder = nil
        }
                
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            if self.textField.isFirstResponder {
                self.separatorView.backgroundColor = .highlited
            } else {
                self.separatorView.backgroundColor = .lightGray
            }
        }
    }
    
    @objc private func textFieldEndEditing() {
        textField.resignFirstResponder()
        animateTextCell()
    }
    
    @objc private func becomeTextFieldFirstResponder() {
        textField.becomeFirstResponder()
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
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
        static let buttonItemContentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    static let identifier: String = "textFieldCellID"
}
