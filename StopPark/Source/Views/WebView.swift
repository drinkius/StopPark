//
//  WebView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
import WebKit

class WebView: BaseView {
    
    private let url = URL(string: "https://xn--90adear.xn--p1ai/request_main")
    private var web: WKWebView = {
        let w = WKWebView()
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private lazy var checkButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Check", for: .normal)
        btn.addTarget(self, action: #selector(check), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sumbit", for: .normal)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

        
    override func setupView() {
        let urlRequest = URLRequest(url: url!)
        web.load(urlRequest)

        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension WebView {
    private func configureViews() {
        [web, checkButton, submitButton].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [web.topAnchor.constraint(equalTo: topAnchor),
         web.leftAnchor.constraint(equalTo: leftAnchor),
         web.rightAnchor.constraint(equalTo: rightAnchor),
//         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         checkButton.topAnchor.constraint(equalTo: web.bottomAnchor),
         checkButton.leftAnchor.constraint(equalTo: leftAnchor),
//         checkButton.rightAnchor.constraint(equalTo: view.rightAnchor),
         checkButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         
         submitButton.topAnchor.constraint(equalTo: web.bottomAnchor),
         submitButton.leftAnchor.constraint(equalTo: checkButton.rightAnchor),
         submitButton.rightAnchor.constraint(equalTo: rightAnchor),
         submitButton.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension WebView {
    @objc private func check() {
        print("clicked")
            web.evaluateJavaScript("$('post').value = 'Haha';") {
                responce, error in
                print(responce)
                print(error)
            }
        
//        webView.evaluateJavaScript("$('#select2-region_code-bd-container').click();") {
//            responce, error in
//            print(responce)
//            print(error)
//        }


        // h.attr("src", [i.pathname, "?", Date.now()].join(""));
//        webView.evaluateJavaScript("document.querySelector('.checkbox').click();") {
//            responce, error in
//            print(responce)
//            print(error)
//        }
        
//        "document.querySelector('.checkbox').remove();"  // worked!
        //u-form__sbt
    }
    
    @objc private func submit() {
        web.evaluateJavaScript("$('.u-form__sbt').click();") {
            responce, error in
            print(responce)
            print(error)
        }
    }
}
