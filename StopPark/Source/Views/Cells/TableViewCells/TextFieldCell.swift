//
//  TextFieldCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate: class {
    func cell(_ cell: TextFieldCell, formData data: FormData?, didChangedTo text: String?)
}

class TextFieldCell: BaseGroupedTableViewCell {
    
    private weak var delegate: TextFieldCellDelegate?
    private var formData: FormData?
    public weak var pickerDelegate: (UIPickerViewDelegate & UIPickerViewDataSource)?
    public func fill(with data: FormData, dataCount: Int, cellIndex: Int, delegate: TextFieldCellDelegate) {
        self.delegate = delegate
        self.formData = data    
        titleLabel.text = data.rawValue
//        checkSavedData(for: data)
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
            placeholderText = Str.Form.describePlaceholder
        default: textField.keyboardType = .default
        }
        
        if dataCount == 1 {
            destination = .single
        }

        if cellIndex == 0 {
            destination = .top
        } else if cellIndex == dataCount - 1 {
            destination = .bottom
        } else {
            destination = .middle
        }
    }
    public var textFieldText: String? {
        get { return textField.text }
        set {
            textField.text = newValue
            animateTextCell()
        }
    }
    
    public var titleText: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
                
    private lazy var cancelButton: UIBarButtonItem = {
        let btn = UIButton()
        btn.setTitle(Str.Generic.ready, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .highlited
        btn.contentEdgeInsets = .buttonItemContentInset
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
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.font = .systemFont(ofSize: 12)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
        [titleLabel, textField].forEach {
            contentContainer.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Theme.textFieldItemPadding)
        titleLabelBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor)
        
        [titleLabelTopConstraint,
         titleLabel.leftAnchor.constraint(equalTo: textField.leftAnchor),
         titleLabel.rightAnchor.constraint(equalTo: textField.rightAnchor),
         titleLabelBottomConstraint,
         
         textField.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Theme.textFieldItemPadding),
         textField.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .extraPadding),
         textField.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.extraPadding),
         textField.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -Theme.textFieldItemPadding)
            ].forEach { $0.isActive = true }
    }
    
    
    private func checkSavedData(for data: FormData) {
        guard FormData.userPrivacyData.contains(data) else { return }
        guard let text = UserDefaultsManager.getFormData(data) else {
            textField.text = nil
            titleLabelTopConstraint.constant = Theme.textFieldItemPadding
            titleLabelBottomConstraint.constant = .zero
            return
        }

        textField.text = text
        titleLabelTopConstraint.constant = .zero
        titleLabelBottomConstraint.constant = -Theme.textFieldItemPadding
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
            titleLabelBottomConstraint.constant = -Theme.textFieldItemPadding
            textField.placeholder = placeholderText
            titleLabel.textColor = .highlited
        } else {
            titleLabelTopConstraint.constant = Theme.textFieldItemPadding
            titleLabelBottomConstraint.constant = .zero
            textField.placeholder = nil
            titleLabel.textColor = .themeGrayText
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
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
        delegate?.cell(self, formData: formData, didChangedTo: textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextCell()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cell(self, formData: formData, didChangedTo: textField.text)
        animateTextCell()
    }
}

// MARK: - Support
extension TextFieldCell {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
        static let textFieldItemPadding: CGFloat = 14.0
    }
}
