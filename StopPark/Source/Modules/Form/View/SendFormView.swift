//
//  SendFormView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/5/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol SendFormViewDelegate: class {
    func view(_ view: SendFormView, didSendCaptcha captcha: String)
    func view(_ view: SendFormView, sendVerificationCode code: String)
    func view(_ view: SendFormView, didReceiveError error: String)
    func view(_ view: SendFormView, changeCaptchaOn captchaView: CaptchaView)
    func cancelSendingRequest()
    func closeRequestForGood()
}

class SendFormView: BaseView {
        
    public weak var delegate: SendFormViewDelegate?

    private var closeButtonAction: (() -> Void)?

    private var animating: Bool = false
    private var pendingUpdate: ContentDestination?
    
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
    
    private var stackContainerCenterYAnchor: NSLayoutConstraint!
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
        view.changeActionBlock = { [weak self] in self?.refreshCaptcha() }
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var verificationCodeView: EnterCodeView = {
        let view = EnterCodeView()
        view.textFeildDelegate = self
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
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(Str.Generic.cancel, for: .normal)
        btn.setTitleColor(.highlited, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.isHidden = true
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(closeForm), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        isHidden = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewShouldEndEditing)))
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension SendFormView {
    private func configureViews() {
        [stackContainer, closeButton, fillView, cancelButton].forEach {
            addSubview($0)
        }
        [titleLabel].forEach {
            stackContainer.addArrangedSubview($0)
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func configureConstraints() {
        stackContainerCenterYAnchor = stackContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
        [stackContainerCenterYAnchor,
         stackContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
         stackContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         stackContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         
         cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .padding),
         cancelButton.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: .hugePadding),
         cancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -.padding),
         cancelButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
                 
         closeButton.topAnchor.constraint(equalTo: stackContainer.bottomAnchor, constant: .hugePadding),
         closeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: .hugePadding),
         closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         closeButton.heightAnchor.constraint(equalToConstant: 44.0)
            ].forEach { $0.isActive = true }
    }
    
    private func updateContentAnimated(for type: ContentDestination) {
        guard !animating else {
            pendingUpdate = type
            return
        }
        animating = true
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.titleLabel.alpha = 0
            self.closeButton.alpha = 0
            self.captchaView.alpha = 0
            self.verificationCodeView.alpha = 0
        }, completion: { _ in
            self.updateContent(for: type)
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.titleLabel.alpha = 1
                self.closeButton.alpha = 1
                self.captchaView.alpha = 1
                self.verificationCodeView.alpha = 1
            }, completion: { _ in
                self.animating = false
                if let update = self.pendingUpdate {
                    self.pendingUpdate = nil
                    self.updateContentAnimated(for: update)
                }
            })
        })
    }
    
    private func updateContent(for type: ContentDestination) {
        if type == .downloadCaptcha {
            guard titleLabel.text != Str.Form.notARobot else { return }
        } else if type == .verifyEmail {
            guard titleLabel.text != Str.Form.verifyEmail else { return }
        }
        closeButton.isHidden = false
        [
        captchaView,
        verificationCodeView,
        ].forEach {
            $0.isHidden = true
            stackContainer.removeArrangedSubview($0)
        }
        switch type {
        case .sendingRequest:
            titleLabel.text = Str.Form.sendingToServer
            closeButton.isHidden = true
            captchaView.imageView.image = nil
        case .requestingCode:
            titleLabel.text = Str.Form.requestingCode
            closeButton.isHidden = true
            captchaView.imageView.image = nil
        case .checkingCode:
            titleLabel.text = Str.Form.checkingCode
            closeButton.isHidden = true
            captchaView.imageView.image = nil
        case .verifyEmail:
            titleLabel.text = Str.Form.verifyEmail
            closeButton.setTitle(Str.Form.sendToCheck, for: .normal)
            closeButtonAction = sendEmailVerificationCode
            stackContainer.addArrangedSubview(verificationCodeView)
            verificationCodeView.isHidden = false
        case .failedCaptcha:
            titleLabel.text = Str.Generic.errorLoadCaptcha
            closeButton.setTitle(Str.Generic.try, for: .normal)
            closeButtonAction = closeForm
        case .captchaUploaded:
            titleLabel.text = Str.Form.notARobot
            closeButton.setTitle(Str.Form.sendToCheck, for: .normal)
            closeButtonAction = sendCaptcha
            stackContainer.addArrangedSubview(captchaView)
            captchaView.isHidden = false
        case .successfulFinish:
            titleLabel.text = Str.Form.statementSended
            closeButton.setTitle(Str.Form.goToStatementsList, for: .normal)
            closeButtonAction = finishRequest
        case .uploadImages:
            titleLabel.text = Str.Form.loadingImages
            closeButton.isHidden = true
        case .downloadCaptcha:
            titleLabel.text = Str.Form.loadingCaptcha
            closeButton.setTitle("", for: .normal)
            closeButton.isHidden = true
        case .refreshCaptcha:
            titleLabel.text = Str.Form.updateCaptcha
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
    
    private func refreshCaptcha() {
        InvAnalytics.shared.sendEvent(event: .formClickRefreshCaptcha)
        delegate?.view(self, changeCaptchaOn: captchaView)
        updateContentAnimated(for: .refreshCaptcha)
    }
}

// MARK: - Actions
extension SendFormView {
    public func setOpen(_ open: Bool, frame: CGRect, block: @escaping () -> ()) {
        guard frame != .zero else { return }
        isHidden = open ? false : true
        fillView.frame = frame

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.fillView.frame = .init(x: .nanoPadding, y: .nanoPadding + 64, width: self.bounds.width - (2 * .nanoPadding), height: self.bounds.height - 64 - (2 * .nanoPadding))
        }, completion: { _ in
            block()
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                self.fillView.frame = .init(origin: .zero, size: self.bounds.size)
            }, completion: { _ in
                self.backgroundColor = open ? .highlited : .clear
                self.cancelButton.isHidden = open ? false : true
                UIView.animate(withDuration: 0.4, animations: {
                    self.fillView.alpha = open ? 0 : 1
                    self.cancelButton.alpha = open ? 1.0 : 0
                }, completion: { _ in
                })
            })
        })
    }
    
    public func updateView(for type: Destination) {
        print("Dumpin++")
        dump(type)
        Vibration.light.vibrate()
        switch type {
        case .getCaptcha(let url): getCaptchaFromURL(url)
        case .uploadImages: updateContentAnimated(for: .uploadImages)
        case .startSendFullForm: updateContentAnimated(for: .sendingRequest)
        case .endSendFullForm: updateContentAnimated(for: .successfulFinish)
        case .requestingCodeEmail: updateContentAnimated(for: .requestingCode)
        case .enterVerificationCode: updateContentAnimated(for: .verifyEmail)
        case .checkingCode: updateContentAnimated(for: .checkingCode)
        }
    }
    
    public func onKeyboard(_ notification: Notification) {
        stackContainerCenterYAnchor.constant = 0

        if notification.name == UIApplication.keyboardWillShowNotification {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let height = keyboardFrame?.height
            stackContainerCenterYAnchor.constant = -(height ?? 243) / 2
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    @objc
    private func closeButtonTapped() {
        closeButtonAction?()
    }

    // Tutai
    private func sendEmailVerificationCode() {
        viewShouldEndEditing()
        guard let text = verificationCodeView.textFieldText, text != "" else {
            delegate?.view(self, didReceiveError: Str.Form.enterCaptcha)
            return
        }
        delegate?.view(self, sendVerificationCode: text)
        updateContentAnimated(for: .checkingCode)
    }

    private func sendCaptcha() {
        viewShouldEndEditing()
        guard let text = captchaView.textFieldText, text != "" else {
            delegate?.view(self, didReceiveError: Str.Form.enterCaptcha)
            return
        }
        delegate?.view(self, didSendCaptcha: text)
        updateContentAnimated(for: .sendingRequest)
    }

    @objc
    private func closeForm() {
        delegate?.cancelSendingRequest()
    }

    private func finishRequest() {
        delegate?.closeRequestForGood()
    }
    
    @objc private func viewShouldEndEditing() {
        captchaView.endEditing(true)
        verificationCodeView.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SendFormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCaptcha()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.placeholder = Str.Form.enterCaptcha
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
        static let buttonItemHeight: CGFloat = 25.0
    }
    
    enum Destination {
        case requestingCodeEmail
        case enterVerificationCode
        case checkingCode
        case getCaptcha(URL?)
        case uploadImages
        case startSendFullForm
        case endSendFullForm
    }
    
    private enum ContentDestination {
        case sendingRequest
        case requestingCode
        case checkingCode
        case verifyEmail
        case downloadCaptcha
        case failedCaptcha
        case captchaUploaded
        case uploadImages
        case successfulFinish
        case refreshCaptcha
    }
}
