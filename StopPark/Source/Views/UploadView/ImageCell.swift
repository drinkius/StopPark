//
//  ImageCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class ImageCell: BaseCollectionViewCell {
    
    public func fill(with image: UIImage?) {
        guard let image = image else { return }
        uploadImage.image = image
    }
    
    private var uploadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Theme.imageItemCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.delete, for: .normal)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension ImageCell {
    private func configureViews() {
        [uploadImage, deleteButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [uploadImage.leftAnchor.constraint(equalTo: leftAnchor, constant: .padding),
         uploadImage.centerYAnchor.constraint(equalTo: centerYAnchor),
         uploadImage.widthAnchor.constraint(equalToConstant: Theme.imageItemHeight),
         uploadImage.heightAnchor.constraint(equalToConstant: Theme.imageItemHeight),
         
         deleteButton.topAnchor.constraint(equalTo: uploadImage.topAnchor),
         deleteButton.leftAnchor.constraint(equalTo: uploadImage.leftAnchor),
         deleteButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),
         deleteButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension ImageCell {
    @objc private func deleteAction() {
        uploadImage.image = nil
    }
}

// MARK: - Support
extension ImageCell {
    enum Theme {
        static let imageItemHeight: CGFloat = 50.0
        static let imageItemCornerRadius: CGFloat = 5.0
        static let buttonItemHeight: CGFloat = 20.0
        static let buttonItemWidth: CGFloat = buttonItemHeight
        static let buttonItemCornerRadius: CGFloat = buttonItemHeight / 2
    }
    
    static let identifier: String = "imageCellId"
}
