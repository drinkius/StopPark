//
//  SendFormView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/5/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol SendFormViewDelegate: class {
    func formShouldSend(withCaptcha captcha: String)
    func errorShouldShow(withText text: String)
    func formVCShouldClose()
}

class SendFormView: BaseView {
        
    public weak var delegate: SendFormViewDelegate?
    
    private var type: ContentDestination = .sendingRequest
    private var fillView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.layer.cornerRadius = .standartCornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .highlited
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = .padding
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
        
    private lazy var captchaView: CaptchaView = {
        let view = CaptchaView()
        view.textFeildDelegate = self
        view.changeActionBlock = { print("change") }
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.highlited, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.isHidden = true
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        isHidden = true
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension SendFormView {
    private func configureViews() {
        [stackContainer, closeButton, fillView].forEach {
            addSubview($0)
        }
        [titleLabel, captchaView].forEach {
            stackContainer.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        [stackContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
         stackContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
         stackContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         stackContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
                 
         closeButton.topAnchor.constraint(equalTo: stackContainer.bottomAnchor, constant: .hugePadding),
         closeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         closeButton.heightAnchor.constraint(equalToConstant: 44.0)
            ].forEach { $0.isActive = true }
    }
    
    private func updateContentAnimated(for type: ContentDestination) {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.closeButton.alpha = 0
            self.captchaView.alpha = 0
        }, completion: { _ in
            self.updateContent(for: type)
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 1
                self.closeButton.alpha = 1
                self.captchaView.alpha = 1
            })
        })
    }
    
    private func updateContent(for type: ContentDestination) {
        if type == .downloadCaptcha {
            guard titleLabel.text != "Подтвердите, что Вы не робот" else { return }
        }
        closeButton.isHidden = false
        captchaView.isHidden = true
        switch type {
        case .sendingRequest:
            titleLabel.text = "Отправляем запрос на сервер..."
            closeButton.isHidden = true
            captchaView.imageView.image = nil
        case .failedCaptcha:
            titleLabel.text = Strings.captchaError
            closeButton.setTitle("Попробовать снова", for: .normal)
            closeButton.addTarget(self, action: #selector(closeForm), for: .touchUpInside)
        case .captchaUploaded:
            titleLabel.text = "Подтвердите, что Вы не робот"
            closeButton.setTitle("Отправить на проверку", for: .normal)
            closeButton.addTarget(self, action: #selector(sendCaptcha), for: .touchUpInside)
            captchaView.isHidden = false
        case .closeForm:
            titleLabel.text = "Ваше заявление отправлено! Информация о данном обращении на главной странице."
            closeButton.setTitle("Перейти к списку обращений", for: .normal)
            closeButton.addTarget(self, action: #selector(closeForm), for: .touchUpInside)
        case .uploadImages:
            titleLabel.text = "Фотографии загружаются на сервер, пожалуйста, подождите немного..."
            closeButton.isHidden = true
        case .downloadCaptcha:
            titleLabel.text = "Загружаем капчу..."
            closeButton.setTitle("", for: .normal)
            closeButton.isHidden = true
        }
    }
    
    private func getCaptchaFromURL(_ url: URL?) {
        guard let url = url else {
            updateContentAnimated(for: .failedCaptcha)
            return
        }
        updateContentAnimated(for: .downloadCaptcha)
        captchaView.imageView.downloadCapture(with: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(_): self?.updateContentAnimated(for: .failedCaptcha)
                case .success: self?.updateContentAnimated(for: .captchaUploaded)
                }
            }
        }
    }
}

// MARK: - Actions
extension SendFormView {
    public func animateFillingBackground(with frame: CGRect, block: @escaping () -> ()) {
        guard frame != .zero else { return }
        isHidden = false
        fillView.frame = frame

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.fillView.frame = .init(x: .nanoPadding, y: .nanoPadding + 64, width: self.bounds.width - (2 * .nanoPadding), height: self.bounds.height - 64 - (2 * .nanoPadding))
        }, completion: { _ in
            block()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                self.fillView.layer.cornerRadius = 0
                self.fillView.frame = .init(origin: .zero, size: self.bounds.size)
            }, completion: { _ in
                self.backgroundColor = .highlited
                UIView.animate(withDuration: 0.4, animations: {
                    self.fillView.alpha = 0
                }, completion: { _ in
                    self.fillView.alpha = 0
                })
            })
        })
    }
    
    public func updateView(for type: Destination) {
        switch type {
        case .getCaptcha(let url): getCaptchaFromURL(url)
        case .uploadImages: updateContentAnimated(for: .uploadImages)
        case .startSendFullForm: updateContentAnimated(for: .sendingRequest)
        case .endSendFullForm: updateContentAnimated(for: .closeForm)
        }
    }
    
    @objc private func sendCaptcha() {
        guard let text = captchaView.textFieldText else {
            delegate?.errorShouldShow(withText: "Введите капчу")
            return
        }
        delegate?.formShouldSend(withCaptcha: text)
        updateContentAnimated(for: .sendingRequest)
    }
    
    @objc private func closeForm() {
        delegate?.formVCShouldClose()
    }
}

// MARK: - UITextFieldDelegate
extension SendFormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendCaptcha()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.placeholder = "Введите капчу"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = nil
        return true
    }
}

// MARK: - Support
extension SendFormView {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
        static let buttonItemContentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    enum Destination {
        case getCaptcha(URL?)
        case uploadImages
        case startSendFullForm
        case endSendFullForm
    }
    
    private enum ContentDestination {
        case sendingRequest
        case downloadCaptcha
        case failedCaptcha
        case captchaUploaded
        case uploadImages
        case closeForm
    }
}
