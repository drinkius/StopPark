//
//  UploadView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

protocol UploadViewDelegate: class {
    func needsPresent()
}

class UploadView: BaseView {
    
    public var images: [UIImage] = [] {
        didSet { collectionView.reloadData() }
    }
    public weak var delegate: UploadViewDelegate?
            
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
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
extension UploadView {
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

extension UploadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UploadView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return 1
        default: print(images.count); return images.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadImageCell.identifier, for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath)
            if let imageCell = cell as? ImageCell {
                imageCell.fill(with: images[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Theme.cellItemHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1: delegate?.needsPresent()
        default: tableView.allowsSelection = false
        }
    }
}

// MARK: - Support
extension UploadView {
    enum Theme {
        static let cellItemHeight: CGFloat = 70.0
    }
}
