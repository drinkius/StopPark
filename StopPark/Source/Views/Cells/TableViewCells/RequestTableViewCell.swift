//
//  RequestTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/3/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class RequestTableViewCell: BaseGroupedTableViewCell {
    
    public func fill(with data: Appeal) {
        timeLabel.text = "Обращение от " + "\(data.time.toCalendarDate())"
        idLabel.attributedText = "ID обращения:\n"
            .attributed
            .appendBold(data.id, withFontSize: 12)
        codeLabel.attributedText = "Код проверки статуса обращения:\n"
            .attributed
            .appendBold(data.code, withFontSize: 12)
        
        if data.status == true {
            statusImage.image = .consider
            statusImage.tintColor = .green
        } else {
            statusImage.image = .waiting
            statusImage.tintColor = .gray
        }
    }
        
    private var timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Обращение от "
        lbl.textColor = .themeGrayText
        lbl.font = .systemFont(ofSize: 10)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var statusImage: UIImageView = {
        let image = UIImageView()
        image.image = .add
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var idLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ID обращения: "
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var codeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Код проверки статуса обращения: "
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func setupView() {
        super.setupView()
        destination = .single
        configureViews()
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
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
extension RequestTableViewCell {
    private func configureViews() {
        [timeLabel, statusImage, separatorView, idLabel, codeLabel].forEach {
            contentContainer.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [timeLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .nanoPadding),
         timeLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .nanoPadding),
         timeLabel.rightAnchor.constraint(equalTo: statusImage.leftAnchor, constant: -.nanoPadding),
         timeLabel.bottomAnchor.constraint(equalTo: statusImage.bottomAnchor),
         
         statusImage.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: .nanoPadding),
         statusImage.heightAnchor.constraint(equalToConstant: Theme.imageItemHeight),
         statusImage.widthAnchor.constraint(equalToConstant: Theme.imageItemWidth),
         statusImage.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.nanoPadding),
         
         separatorView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: .nanoPadding),
         separatorView.heightAnchor.constraint(equalToConstant: .separatorHeight),
         separatorView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor),
         separatorView.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
         
         idLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: .smallPadding),
         idLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .smallPadding),
         idLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.smallPadding),
         
         codeLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: .smallPadding),
         codeLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: .smallPadding),
         codeLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -.smallPadding),
         codeLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -.smallPadding)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Support
extension RequestTableViewCell {
    enum Theme {
        static let imageItemHeight: CGFloat = 20.0
        static let imageItemWidth: CGFloat = imageItemHeight
    }
    enum Status {
        case waiting
        case consider
    }
}
