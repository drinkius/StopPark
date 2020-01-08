//
//  ImageCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate: class {
    func delete(image: UIImage?)
}

class ImageCollectionViewCell: BaseCollectionViewCell {
    
    public weak var delegate: ImageCollectionViewCellDelegate?
    
    public func fill(with image: UIImage?) {
        guard let image = image else { return }
        uploadImage.image = image
    }
    
    private var uploadImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Theme.imageItemCornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.delete, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.themeMainTitle.withAlphaComponent(0.5)
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
extension ImageCollectionViewCell {
    private func configureViews() {
        [uploadImage, deleteButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [uploadImage.topAnchor.constraint(equalTo: topAnchor, constant: .smallPadding),
         uploadImage.leftAnchor.constraint(equalTo: leftAnchor, constant: .smallPadding),
         uploadImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -.smallPadding),
         uploadImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.smallPadding),
         
         deleteButton.topAnchor.constraint(equalTo: uploadImage.topAnchor, constant: -(Theme.buttonItemWidth / 3)),
         deleteButton.leftAnchor.constraint(equalTo: uploadImage.leftAnchor, constant: -(Theme.buttonItemWidth / 3)),
         deleteButton.widthAnchor.constraint(equalToConstant: Theme.buttonItemWidth),
         deleteButton.heightAnchor.constraint(equalToConstant: Theme.buttonItemHeight)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension ImageCollectionViewCell {
    @objc private func deleteAction() {
        UIView.animate(withDuration: 0.3, animations: {
            [self.uploadImage, self.deleteButton].forEach {
                $0.alpha = 0
            }
        }, completion: { _ in
            [self.uploadImage, self.deleteButton].forEach {
                $0.alpha = 1
            }
            self.delegate?.delete(image: self.uploadImage.image)
        })
    }
}

// MARK: - Support
extension ImageCollectionViewCell {
    enum Theme {
        static let imageItemHeight: CGFloat = 50.0
        static let imageItemCornerRadius: CGFloat = 5.0
        static let buttonItemHeight: CGFloat = 15.0
        static let buttonItemWidth: CGFloat = buttonItemHeight
        static let buttonItemCornerRadius: CGFloat = buttonItemHeight / 2
    }
    
    static let identifier: String = "imageCellId"
}
