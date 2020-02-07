//
//  TemplatesPayVC.swift
//  StopPark
//
//  Created by Arman Turalin on 1/19/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit
import StoreKit

class PayVC: UIViewController {
    
    private let presenter: PayPresenter!
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = .payBackground
        image.alpha = 0.1
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
        
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.delete, for: .normal)
        btn.tintColor = .themeButtonTint
        btn.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
                
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = presenter.titleText
        lbl.textColor = .themeMainTitle
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 35, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var describeViews: [PayDescribeView] = {
        var array: [PayDescribeView] = []
        for i in 0..<presenter.describes.count {
            let view = PayDescribeView()
            view.fill(with: presenter.describes[i])
            view.translatesAutoresizingMaskIntoConstraints = false
            array.append(view)
        }
        return array
    }()
    
    private var buttonsVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5.0
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var donateButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5.0
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isHidden = presenter.donateButtonsIsHidden
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var donateButtons: [LoadingButton] = {
        var array: [LoadingButton] = []
        for i in 0..<presenter.donateButtons.count {
            let btn = LoadingButton()
            btn.setTitle(presenter.donateButtons[i].text, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
            btn.titleLabel?.numberOfLines = 0
            btn.titleLabel?.textAlignment = .center
            btn.backgroundColor = presenter.donateButtons[i].color
            btn.layer.cornerRadius = .standartCornerRadius
            btn.layer.masksToBounds = true
            btn.addTarget(self, action: #selector(onPay(_:)), for: .touchUpInside)
            btn.tag = i
            btn.translatesAutoresizingMaskIntoConstraints = false
            array.append(btn)
        }
        return array
    }()
        
    private lazy var payButton: LoadingButton = {
        let btn = LoadingButton()
        btn.setTitle("ВСЕГО ЗА 229 ₽", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.titleLabel?.numberOfLines = 0
        btn.backgroundColor = .highlited
        btn.layer.cornerRadius = .standartCornerRadius
        btn.layer.masksToBounds = true
        btn.isHidden = presenter.payButtonIsHidden
        btn.addTarget(self, action: #selector(onPay(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var termsTextView: UITextView = {
        let view = UITextView()
        view.attributedText = presenter.termsText
        view.delegate = self
        view.textColor = .gray
        view.isScrollEnabled = false
        view.sizeToFit()
        view.textAlignment = .center
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 8, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loaderView: LoaderView = {
        let view = LoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(with presenter: PayPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        print("vc died")
    }
}

// MARK: - Private Functions
extension PayVC {
    private func setupView() {
        view.backgroundColor = .themeContainer
        configureViews()
        configureConstraints()
        configureIAPs()
    }
    
    private func configureViews() {
        [backgroundImage, closeButton, titleLabel, buttonsVerticalStack, termsTextView].forEach { view.addSubview($0) }
        describeViews.forEach { view.addSubview($0) }
        [payButton, donateButtonsStack].forEach { buttonsVerticalStack.addArrangedSubview($0) }
        donateButtons.forEach { donateButtonsStack.addArrangedSubview($0) }
        [loaderView].forEach { view.addSubview($0) }
    }
    
    private func configureConstraints() {
        describeViews.forEach {
            $0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .hugePadding).isActive = true
            $0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.hugePadding).isActive = true
        }
        [closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .nanoPadding),
         closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.padding),
         closeButton.heightAnchor.constraint(equalToConstant: Theme.closeItemSize.height),
         closeButton.widthAnchor.constraint(equalToConstant: Theme.closeItemSize.width),
         
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.titleItemPadding),
         titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .hugePadding),
         titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.hugePadding),
         
         describeViews[0].topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .hugePadding),
         
         describeViews[1].topAnchor.constraint(equalTo: describeViews[0].bottomAnchor, constant: .nanoPadding),

         describeViews[2].topAnchor.constraint(equalTo: describeViews[1].bottomAnchor, constant: .nanoPadding),
         describeViews[2].bottomAnchor.constraint(lessThanOrEqualTo: buttonsVerticalStack.topAnchor),

         buttonsVerticalStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .hugePadding),
         buttonsVerticalStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.hugePadding),
         buttonsVerticalStack.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight),
                  
         termsTextView.topAnchor.constraint(equalTo: buttonsVerticalStack.bottomAnchor, constant: .padding),
         termsTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .padding),
         termsTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.padding),
         termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.nanoPadding),
         
         backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
         backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
         backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
         backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         loaderView.topAnchor.constraint(equalTo: view.topAnchor),
         loaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
         loaderView.rightAnchor.constraint(equalTo: view.rightAnchor),
         loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    private func configureIAPs() {
        loaderView.startAnimating()
        IAPManager.shared.fetchAvailableProduct() { [weak self] result in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                self.loaderView.stopAnimating()
                
                switch result {
                case let .failure(text):
                    self.showMessage(text, addAction: [self.dissmisAction()])
                case .success: break
                }
            }
        }
    }
}

// MARK: - Actions
extension PayVC {
    @objc private func onClose() {
        dismiss(animated: true)
    }
    @objc private func onPay(_ sender: UIButton) {
        guard let key = IAPKey(rawValue: sender.tag) else {
            showErrorMessage("Продукт не найден, попробуйте позже.")
            donateButtons.forEach { $0.stopAnimating() }
            return
        }
        
        IAPManager.shared.purchase(on: key) { [weak self] message, product, transaction in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                self.donateButtons.forEach { $0.stopAnimating() }
                
                switch message {
                case .purchased:
                    UserDefaultsManager.setIAPTransactionHashValue(transaction.hashValue)
                    self.showMessage("Спасибо большое за поддержку проекта! 🥳", addAction: [self.dissmisAction("Ок")])
                case .restored:
                    UserDefaultsManager.setIAPTransactionHashValue(transaction.hashValue)
                    self.showMessage(message.errorDescription, addAction: [self.dissmisAction("Ок")])
                case .noProductIDsFound, .noProductsFound, .paymentWasCancelled, .productRequestFailed, .error:
                    self.showErrorMessage(message.errorDescription)
                case .cancelled: break
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension PayVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

// MARK: - Support
extension PayVC {
    enum Theme {
        static let buttonItemHeight: CGFloat = 44.0
        static let titleItemPadding: CGFloat = Display.height * 1/7
        static let closeItemSize: CGSize = .init(width: 25, height: 25)
    }
}
