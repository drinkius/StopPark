//
//  ImageInputCell.swift
//  StopPark
//
//  Created by Arman Turalin on 12/27/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol ImageInputCellDelegate: class {
    func needsPresent()
}

class ImageInputCell: BaseTableViewCell {
    
    public var images: [UIImage] = [] {
        didSet { collectionView.reloadData() }
    }
    public weak var delegate: ImageInputCellDelegate?
            
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        view.register(LoadImageCell.self, forCellWithReuseIdentifier: LoadImageCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension ImageInputCell {
    private func configureViews() {
        [collectionView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [collectionView.topAnchor.constraint(equalTo: topAnchor),
         collectionView.leftAnchor.constraint(equalTo: leftAnchor),
         collectionView.rightAnchor.constraint(equalTo: rightAnchor),
         collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - UICollectionView
extension ImageInputCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1: return 1
        default: print(images.count); return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadImageCell.identifier, for: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath)
            if let imageCell = cell as? ImageCell {
                imageCell.fill(with: images[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1: delegate?.needsPresent()
        default: collectionView.allowsSelection = false
        }
    }
}

// MARK: - Support
extension ImageInputCell {
    static let identifier: String = "imageInputCellID"
}
