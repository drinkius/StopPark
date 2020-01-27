//
//  ClosedTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class ClosedTableViewCell: BaseGroupedTableViewCell {
    
    public func fill(with data: FormData, dataCount: Int, cellIndex: Int) {
        guard let dataText = UserDefaultsManager.getFormData(data) else { return }
    
        titleLabel.text = data.rawValue
        dataLabel.text = dataText
        
        if cellIndex == 0 {
            destination = .top
        } else if cellIndex == dataCount - 1 {
            destination = .bottom
        } else {
            destination = .middle
        }
    }
    
    private var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "title"
        lbl.textColor = .themeGrayText
        lbl.font = .systemFont(ofSize: 10)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var dataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "data"
        lbl.textColor = .themeDarkGrayText
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var lockImage: UIImageView = {
        let im = UIImageView()
        im.image = .lock
        im.contentMode = .scaleAspectFill
        im.tintColor = .themeDiffrentImageTint
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()

    override func setupView() {
        super.setupView()
        contentContainer.backgroundColor = .themeDarkSmokeBackground
        configureViews()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: Theme.contentContainerMargin, bottom: 0, right: Theme.contentContainerMargin)
        contentContainer.frame = contentContainer.frame.inset(by: margins)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        return
    }
}

// MARK: - Private Functions
extension ClosedTableViewCell {
    private func configureViews() {
        [labelStack, lockImage].forEach {
            contentContainer.addSubview($0)
        }
        [titleLabel, dataLabel].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        [labelStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .nanoPadding),
         labelStack.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .extraPadding),
         labelStack.rightAnchor.constraint(equalTo: lockImage.leftAnchor, constant: -.nanoPadding),
         labelStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.nanoPadding),
         
         lockImage.widthAnchor.constraint(equalToConstant: Theme.imageItemWidth),
         lockImage.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .padding),
         lockImage.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.hugePadding),
         lockImage.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.padding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension ClosedTableViewCell {
    enum Theme {
        static let contentContainerMargin: CGFloat = 10.0
        static let imageItemWidth: CGFloat = 20.0
    }
}
