//
//  FormViewController.swift
//  StopPark
//
//  Created by Arman Turalin on 12/10/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
import WebKit

class FormViewController: UIViewController {
    
    private var webView: WebView = {
        let w = WebView()
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private var formView: FormView = {
        let view = FormView()
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
        
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [webView, formView].forEach {
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
         formView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension FormViewController {
}
