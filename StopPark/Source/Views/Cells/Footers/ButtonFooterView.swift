//
//  ButtonFooterView.swift
//  StopPark
//
//  Created by Arman Turalin on 1/10/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class ButtonFooterView: BaseView {
    
    public func fill(buttonName name: String, editAction: (() -> Void)?, activateAction: (() -> Void)?) {
        editButton.setTitle(name, for: .normal)
        editActionBlock = editAction
        activateActionBlock = activateAction
    }
    
    private var editActionBlock: (() -> Void)?
    private lazy var editButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.highlited, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 10)
        btn.titleLabel?.numberOfLines = 2
        btn.addTarget(self, action: #selector(onEdit(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var buttonVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var buttonHorizontalStacks: [UIStackView] = {
        var array: [UIStackView] = []
        for i in 0..<2 {
            let view = UIStackView()
            view.axis = .horizontal
            view.alignment = .fill
            view.spacing = 5
            view.distribution = .fillEqually
            view.translatesAutoresizingMaskIntoConstraints = false
            array.append(view)
        }
        return array
    }()
    
    private let buttonNames: [String] = ["Тротуар", "Пешеходный переход", "Пешеходная зона", "Неположенное место"]
    private lazy var templateButtons: [UIButton] = {
        var array: [UIButton] = []
        for i in 0..<4 {
            let btn = UIButton()
            btn.titleLabel?.font = .systemFont(ofSize: 12)
            btn.titleLabel?.numberOfLines = 0
            btn.layer.cornerRadius = .standartCornerRadius
            btn.backgroundColor = .highlited
            btn.addTarget(self, action: #selector(onSetTemplate), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            array.append(btn)
        }
        return array
    }()
    
    private lazy var blur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0.8
        view.layer.cornerRadius = .standartCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private var activateActionBlock: (() -> Void)?
    private lazy var activateButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Открыть доступ", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(.highlited, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.layer.cornerRadius = .standartCornerRadius
        btn.backgroundColor = .white
        btn.contentEdgeInsets = .buttonItemContentInset
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(onActivate), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
        configureTemplateButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = buttonVerticalStack.frame
    }
}

// MARK: - Private Functions
extension ButtonFooterView {
    private func configureViews() {
        [editButton, buttonVerticalStack, blur, activateButton].forEach {
            addSubview($0)
        }
        buttonHorizontalStacks.forEach {
            buttonVerticalStack.addArrangedSubview($0)
        }
        [templateButtons[0], templateButtons[1]].forEach {
            buttonHorizontalStacks[0].addArrangedSubview($0)
        }
        [templateButtons[2], templateButtons[3]].forEach {
            buttonHorizontalStacks[1].addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        [buttonVerticalStack.topAnchor.constraint(equalTo: topAnchor, constant: .padding),
         buttonVerticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: .extraPadding),
         buttonVerticalStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -.extraPadding),
         buttonVerticalStack.heightAnchor.constraint(equalToConstant: 70),
         
         activateButton.centerYAnchor.constraint(equalTo: blur.centerYAnchor),
         activateButton.centerXAnchor.constraint(equalTo: blur.centerXAnchor),

         editButton.topAnchor.constraint(equalTo: buttonVerticalStack.bottomAnchor, constant: .padding),
         editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -.hugePadding),
         editButton.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: .hugePadding),
         editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
    
    private func configureTemplateButtons() {
        for (i, button) in templateButtons.enumerated() {
            let title = buttonNames[i]
            button.setTitle(title, for: .normal)
        }
    }
}

// MARK: - Actions
extension ButtonFooterView {
    @objc private func onEdit(_ sender: UIButton) {
        editActionBlock?()
    }
    
    @objc private func onSetTemplate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.templateButtons.forEach {
                $0.backgroundColor = .highlited
            }
            sender.backgroundColor = #colorLiteral(red: 0.0267679859, green: 0.3765846789, blue: 0.6633296609, alpha: 1)
        }
        print("template button clicked")
    }
    
    @objc private func onActivate(_ sender: UIButton) {
        activateActionBlock?()
//        UIView.animate(withDuration: 0.3, animations: {
//            self.blur.alpha = 0
//            sender.alpha = 0
//        }, completion: { _ in
//            self.blur.isHidden = true
//            sender.isHidden = true
//        })
    }
}
