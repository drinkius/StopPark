//
//  CaptchaView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/17/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class CaptchaView: BaseView {
    
    public var changeActionBlock: (() -> ())?
    public weak var textFeildDelegate: UITextFieldDelegate? {
        didSet { textField.delegate = textFeildDelegate }
    }
    public var textFieldText: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    private lazy var changeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.update, for: .normal)
        btn.tintColor = .highlited
        btn.backgroundColor = .white
        btn.layer.cornerRadius = .standartCornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(change), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = .standartCornerRadius
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var containerTextInput: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = .standartCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.returnKeyType = .send
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: "Введите капчу", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.textAlignment = .center
        tf.autocapitalizationType = .allCharacters
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
        
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension CaptchaView {
    private func configureViews() {
        [changeButton, imageView, containerTextInput, textField].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [heightAnchor.constraint(greaterThanOrEqualToConstant: Theme.containerItemHeight),
         
         changeButton.topAnchor.constraint(equalTo: topAnchor),
         changeButton.leftAnchor.constraint(equalTo: leftAnchor),
         changeButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         changeButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),

         imageView.topAnchor.constraint(equalTo: changeButton.bottomAnchor),
         imageView.leftAnchor.constraint(equalTo: changeButton.rightAnchor),
         imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         imageView.heightAnchor.constraint(equalToConstant: Theme.imageItemHeight),

         containerTextInput.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .padding),
         containerTextInput.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         containerTextInput.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         containerTextInput.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.nanoPadding),

         textField.topAnchor.constraint(equalTo: containerTextInput.topAnchor, constant: .nanoPadding),
         textField.leftAnchor.constraint(equalTo: containerTextInput.leftAnchor, constant: .padding),
         textField.rightAnchor.constraint(equalTo: containerTextInput.rightAnchor, constant: -.padding),
         textField.bottomAnchor.constraint(equalTo: containerTextInput.bottomAnchor, constant: -.nanoPadding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension CaptchaView {    
    @objc private func change() {
        changeActionBlock?()
    }
}

// MARK: - Support
extension CaptchaView {
    enum Theme {
        static let containerItemHeight: CGFloat = buttonItemHeight + imageItemHeight + .nanoPadding + 44.0
        static let buttonItemHeight: CGFloat = 30.0
        static let buttonItemWidth: CGFloat = buttonItemHeight
        static let imageItemHeight: CGFloat = (Display.width - (2 * .hugePadding)) / 6.5
    }
}
