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
    
    private var formView: FormView = {
        let view = FormView()
        view.isHidden = true
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
        title = "Сервис приема обращений"
        setupView()
    }
}

// MARK: - Private Functions
extension FormViewController {
    private func setupView() {
        view.backgroundColor = .red
        showInfoIfNeeded()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [webView, formView, loader, captureView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [webView.topAnchor.constraint(equalTo: view.topAnchor),
         webView.leftAnchor.constraint(equalTo: view.leftAnchor),
         webView.rightAnchor.constraint(equalTo: view.rightAnchor),
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
         formView.topAnchor.constraint(equalTo: view.topAnchor),
         formView.leftAnchor.constraint(equalTo: view.leftAnchor),
         formView.rightAnchor.constraint(equalTo: view.rightAnchor),
         formView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
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
    private func showInfoIfNeeded() {
//        guard UserDefaultsManager.getInfoSubmit() else {
//            let vc = InformationViewController()
//            present(vc, animated: true)
//            return
//        }
    }
}

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
        webView.loadFinalRequest()
    }
}
