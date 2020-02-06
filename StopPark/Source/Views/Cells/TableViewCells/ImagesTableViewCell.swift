//
//  ImagesTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/2/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol ImagesTableViewCellDelegate: ImageCollectionViewCellDelegate {
    func cell(_ cell: ImagesTableViewCell, addButtonTouchUpInside buttonCell: UICollectionViewCell)
}

class ImagesTableViewCell: BaseGroupedTableViewCell {
    
    public func fill(with images: [UIImage], destination: Destination, delegate: ImagesTableViewCellDelegate?) {
        self.images = images
        self.destination = destination
        self.delegate = delegate
    }
    
    private var images: [UIImage?] = [] {
        didSet {
            collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    private weak var delegate: ImagesTableViewCellDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        view.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func setupView() {
        super.setupView()
        destination = .single
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension ImagesTableViewCell {
    private func configureViews() {
        [collectionView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [collectionView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
         collectionView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor),
         collectionView.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
         collectionView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - UICollectionView
extension ImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return images.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section == 1 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.fill(with: images[indexPath.row])
            imageCell.delegate = delegate
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: contentContainer.frame.height, height: contentContainer.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        delegate?.cell(self, addButtonTouchUpInside: cell)
    }
}
