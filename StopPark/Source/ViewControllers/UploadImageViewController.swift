//
//  UploadImageViewController.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
var phot = UIImage()

class UploadImageViewController: UIViewController {
    
    private lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self, delegate: self)
        return picker
    }()
    
    private lazy var uploadView: UploadView = {
        let view = UploadView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private Functions
extension UploadImageViewController {
    private func setupView() {
        view.backgroundColor = .white
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [uploadView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [uploadView.topAnchor.constraint(equalTo: view.topAnchor),
         uploadView.leftAnchor.constraint(equalTo: view.leftAnchor),
         uploadView.rightAnchor.constraint(equalTo: view.rightAnchor),
         uploadView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - ImagePickerDelegate
extension UploadImageViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        phot = image
        uploadView.images.append(image)
    }
}

// MARK: - UploadViewDelegate
extension UploadImageViewController: UploadViewDelegate {
    func needsPresent() {
        imagePicker.present()
    }
}
