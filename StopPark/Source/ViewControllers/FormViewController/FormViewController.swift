//
//  FormViewController.swift
//  StopPark
//
//  Created by Arman Turalin on 12/10/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
import WebKit

var im: UIImage?

class FormViewController: UIViewController {
        
    private lazy var webView: WebView = {
        let w = WebView()
        w.delegate = self
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
//    private var formView: FormView = {
//        let view = FormView()
////        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.delegate = self
//        view.dataSource = self
        view.isHidden = true
        view.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var loader: Loader = {
        let view = Loader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var captureView: CaptureView = {
        let view = CaptureView()
        view.isHidden = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
                
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Прием обращений"
        setupView()
    }
}

// MARK: - Private Functions
extension FormViewController {
    private func setupView() {
        view.backgroundColor = .red
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [webView, collectionView, loader, captureView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [webView.topAnchor.constraint(equalTo: view.topAnchor),
         webView.leftAnchor.constraint(equalTo: view.leftAnchor),
         webView.rightAnchor.constraint(equalTo: view.rightAnchor),
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
         collectionView.topAnchor.constraint(equalTo: view.topAnchor),
         collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
         collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         loader.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         loader.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.nanoPadding),
         
         captureView.topAnchor.constraint(equalTo: view.topAnchor),
         captureView.leftAnchor.constraint(equalTo: view.leftAnchor),
         captureView.rightAnchor.constraint(equalTo: view.rightAnchor),
         captureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension FormViewController {
}

// MARK: - UICollectionView
//extension FormViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}

// MARK: - WebViewDelegate
extension FormViewController: WebViewDelegate {
    func loading() {
        loader.status = .loading
        print("start")
    }
    
    func done() {
        loader.status = .done
        print("loaded")
//        if UserDefaultsManager.getInfoSubmit() {
//            webView.openForm()
//            print("next page")
//        }
    }
    
    func showCapture(with url: URL?) {
        captureView.imageURL = url
        captureView.isHidden = false
    }
}

extension FormViewController: CaptureViewDelegate {
    func needsUpdateForm() {
        webView.loadAppealRequest()
    }
}
