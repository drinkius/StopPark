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
    
    public var delegate: CaptureViewDelegate?
    
    public var imageURL: URL? {
        didSet { downloadImage() }
    }
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.backgroundColor = .red
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
        [containerView, imageView, containerTextInput, textField, sendButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: Theme.containerItemHeight),
         containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: Theme.containerItemWidth),
         containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
         containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
        
         imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .nanoPadding),
         imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .nanoPadding),
         imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.nanoPadding),
         imageView.heightAnchor.constraint(equalToConstant: Theme.imageViewItemHeight),
        
         containerTextInput.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .nanoPadding),
         containerTextInput.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: .nanoPadding),
         containerTextInput.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -.nanoPadding),
         containerTextInput.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.nanoPadding),

         textField.topAnchor.constraint(equalTo: containerTextInput.topAnchor, constant: .nanoPadding),
         textField.leftAnchor.constraint(equalTo: containerTextInput.leftAnchor, constant: .nanoPadding),
         textField.rightAnchor.constraint(equalTo: sendButton.rightAnchor, constant: -.nanoPadding),
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
    
    @objc private func send() {
        isHidden = true
        UserDefaultsManager.setCaptureImageText(textField.text)
        delegate?.needsUpdateForm()
    }
}

// MARK: - UITextFieldDelegate
extension CaptureView: UITextFieldDelegate {
    
}

extension CaptureView {
    enum Theme {
        static let containerItemHeight: CGFloat = 100.0
        static let containerItemWidth: CGFloat = 100.0
        
        static let imageViewItemHeight: CGFloat = 80.0
        
        static let buttonItemWidth: CGFloat = 44.0
    }
}
