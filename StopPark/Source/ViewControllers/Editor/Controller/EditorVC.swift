//
//  EditorVC.swift
//  StopPark
//
//  Created by Arman Turalin on 1/10/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class EditorVC: UIViewController {

    let router: RouterProtocol

    public var actionBlock: ((String?) -> Void)?
    public var generatedMessage: String? {
        didSet {
            textView.text = generatedMessage
        }
    }
    
    private var blur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var contentContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .themeTextViewBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textViewBottomAnchor: NSLayoutConstraint!
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.textColor = .themeTextViewText
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
        
    private var buttonDirection: ButtonDirection = .hide {
        didSet { updateButtonIfNeeded() }
    }
    private var confirmButtonBottomAnchor: NSLayoutConstraint!
    private lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.layer.cornerRadius = .standartCornerRadius
        btn.layer.masksToBounds = true
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.sizeToFit()
        btn.setTitle("Подтвердить", for: .normal)
        btn.backgroundColor = .highlited
        btn.addTarget(self, action: #selector(onAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.layer.cornerRadius = .standartCornerRadius
        btn.layer.masksToBounds = true
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.sizeToFit()
        btn.setTitle("Отмена", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(onAction(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(router: RouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
        print("vc died")
    }
}

// MARK: - Private Functions
extension EditorVC {
    private func setupView() {
        view.backgroundColor = UIColor.themeBlurBackground.withAlphaComponent(0.3)
        hideKeyboardWhenTappedAround()
        observeKeyboard()
        configureViews()
        configureConstraints()
        updateButtonIfNeeded()
    }
    
    private func configureViews() {
        [blur, confirmButton, cancelButton, contentContainer].forEach {
            view.addSubview($0)
        }
        [textView].forEach {
            contentContainer.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        confirmButtonBottomAnchor = confirmButton.bottomAnchor.constraint(equalTo: contentContainer.topAnchor, constant: -.nanoPadding)
        textViewBottomAnchor = textView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.padding)

        [blur.topAnchor.constraint(equalTo: view.topAnchor),
         blur.leftAnchor.constraint(equalTo: view.leftAnchor),
         blur.rightAnchor.constraint(equalTo: view.rightAnchor),
         blur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         contentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         contentContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         contentContainer.heightAnchor.constraint(equalToConstant: Theme.contentContainerItemHeight),
         contentContainer.widthAnchor.constraint(equalToConstant: Theme.contentContainerItemWidth),
         
         textView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .padding),
         textView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .padding),
         textView.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.padding),
         textViewBottomAnchor,
         
         confirmButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         confirmButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
         confirmButtonBottomAnchor,
         confirmButton.leftAnchor.constraint(greaterThanOrEqualTo: cancelButton.rightAnchor, constant: .padding),
         
         cancelButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
         cancelButton.leftAnchor.constraint(equalTo: contentContainer.leftAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: contentContainer.topAnchor, constant: -.nanoPadding),
         cancelButton.rightAnchor.constraint(lessThanOrEqualTo: confirmButton.leftAnchor, constant: .padding)
            ].forEach { $0.isActive = true }
    }
    
    private func updateButtonIfNeeded() {
        switch buttonDirection {
        case .show: confirmButtonBottomAnchor.constant = -.nanoPadding
        case .hide: confirmButtonBottomAnchor.constant = Theme.buttonItemHeight
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Actions
extension EditorVC {
    @objc private func onAction(_ sender: UIButton) {
        Vibration.light.vibrate()
        if sender.backgroundColor == .red {
            InvAnalytics.shared.sendEvent(event: .editorClickCancel)
            actionBlock?(nil)
        } else {
            InvAnalytics.shared.sendEvent(event: .editorClickCancel)
            actionBlock?(textView.text)
        }
        dismiss(animated: true)
    }
    
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let height = keyboardFrame?.height ?? 243
        
        let padding = abs(((Display.height - Theme.contentContainerItemHeight) / 2) - height)
        textViewBottomAnchor.constant = -padding
        
        self.view.layoutIfNeeded()
    }
    
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        textViewBottomAnchor.constant = -.padding
        self.view.layoutIfNeeded()
    }
}

// MARK: - UITextViewDelegate
extension EditorVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != generatedMessage {
            buttonDirection = .show
        } else {
            buttonDirection = .hide
        }
    }
}

// MARK: - Support
extension EditorVC {
    enum Theme {
        static let contentContainerItemHeight: CGFloat = Display.height * 2/3
        static let contentContainerItemWidth: CGFloat = Display.width * 2/3
        static let buttonItemHeight: CGFloat = 22.0
        static let buttonItemContentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    enum ButtonDirection {
        case show
        case hide
    }
}
