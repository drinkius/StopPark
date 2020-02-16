//
//  Form+Collection.swift
//  StopPark
//
//  Created by Arman Turalin on 2/16/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension FormVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionSections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionSections[section].type {
        case .button: return 1
        case .images: return collectionSections[section].rows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionSections[indexPath.section].rows[indexPath.row] {
        case .button:
            let cell: ButtonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case let .image(image):
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.fill(with: image, delegate: self)
            return cell
        }
    }
}
