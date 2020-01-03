//
//  CaptureView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/17/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol CaptureViewDelegate: class {
    func needsUpdateForm()
}

class CaptureView: BaseView {
    
    public weak var delegate: CaptureViewDelegate?
    
    public var imageURL: URL? {
        didSet { downloadImage() }
    }
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Theme.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Проверка от сервера на робота"
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.delete, for: .normal)
        btn.tintColor = .darkGray
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = Theme.cornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var changeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.update, for: .normal)
        btn.tintColor = .darkGray
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = Theme.cornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(change), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var containerTextInput: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = Theme.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.send, for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(send), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension CaptureView {
    private func configureViews() {
        [containerView, changeButton, titleLabel, closeButton, imageView, containerTextInput, textField, sendButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: Theme.containerItemHeight),
         containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
         containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         
         closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding),
         closeButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .padding),
         closeButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         closeButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),
         
         titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding),
         titleLabel.leftAnchor.constraint(equalTo: closeButton.rightAnchor, constant: .padding),
         titleLabel.rightAnchor.constraint(equalTo: changeButton.leftAnchor, constant: -.padding),
         
         changeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .padding),
         changeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.padding),
         changeButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         changeButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),
        
         imageView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
         imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .nanoPadding),
         imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.nanoPadding),
         imageView.bottomAnchor.constraint(lessThanOrEqualTo: containerTextInput.topAnchor),
         imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
         
         containerTextInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .padding),
         containerTextInput.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.padding),
         containerTextInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.padding),

         textField.topAnchor.constraint(equalTo: containerTextInput.topAnchor, constant: .nanoPadding),
         textField.leftAnchor.constraint(equalTo: containerTextInput.leftAnchor, constant: .padding),
         textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -.nanoPadding),
         textField.bottomAnchor.constraint(equalTo: containerTextInput.bottomAnchor, constant: -.nanoPadding),
         
         sendButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),
         sendButton.topAnchor.constraint(equalTo: containerTextInput.topAnchor, constant: .nanoPadding),
         sendButton.rightAnchor.constraint(equalTo: containerTextInput.rightAnchor, constant: -.nanoPadding),
         sendButton.bottomAnchor.constraint(equalTo: containerTextInput.bottomAnchor, constant: -.nanoPadding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension CaptureView {
    private func downloadImage() {
        guard let url = imageURL else { return }
        imageView.downloadCapture(with: url)
    }
    
    @objc private func close() {
        isHidden = true
    }
    
    @objc private func change() {
        print("captcha need to change")
    }
    
    @objc private func send() {
        isHidden = true
        UserDefaultsManager.setCaptureImageText(textField.text)
        delegate?.needsUpdateForm()
    }
}

// MARK: - UITextFieldDelegate
extension CaptureView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isHidden = true
        UserDefaultsManager.setCaptureImageText(textField.text)
        delegate?.needsUpdateForm()
        return true
    }
}

// MARK: - Support
extension CaptureView {
    enum Theme {
        static let containerItemHeight: CGFloat = 250.0
        static let containerItemWidth: CGFloat = 100.0
        
        static let cornerRadius: CGFloat = 10.0
        static let buttonItemHeight: CGFloat = 30.0
        static let buttonItemWidth: CGFloat = buttonItemHeight
        static let imageViewItemHeight: CGFloat = 80.0
    }
}
