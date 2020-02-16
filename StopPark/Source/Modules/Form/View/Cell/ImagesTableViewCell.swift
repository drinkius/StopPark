//
//  ImagesTableViewCell.swift
//  StopPark
//
//  Created by Arman Turalin on 1/2/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol ImagesTableViewCellDelegate: ImageCollectionViewCellDelegate, UICollectionViewDataSource {
    func cell(_ cell: ImagesTableViewCell, addButtonTouchUpInside buttonCell: UICollectionViewCell)
}

class ImagesTableViewCell: BaseGroupedTableViewCell {
    
    public func fill(with destination: Destination, delegate: ImagesTableViewCellDelegate?) {
        self.destination = destination
        self.delegate = delegate
    }
    
    private weak var delegate: ImagesTableViewCellDelegate? {
        didSet {
            collectionView.dataSource = delegate
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        [ImageCollectionViewCell.self, ButtonCollectionViewCell.self].forEach { view.register($0) }
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

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: contentContainer.frame.height, height: contentContainer.frame.height)
    }
}

// MARK: - UICollectionViewDelegate
extension ImagesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        delegate?.cell(self, addButtonTouchUpInside: cell)
    }
}
