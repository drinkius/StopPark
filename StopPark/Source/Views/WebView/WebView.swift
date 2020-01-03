//
//  WebView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewDelegate: class {
    func loading()
    func done()
    func showCapture(with url: URL?)
    func showError(_ text: String?)
}

class WebView: BaseView {
        
    public weak var delegate: WebViewDelegate?
    
    private var isSessionUpdated: Bool = false
    private var eventInfoForm: [FormData: String]?
    private let config = WKWebViewConfiguration()
    private lazy var web: WKWebView = {
        let w = WKWebView(frame: .zero, configuration: config)
        w.navigationDelegate = self
        w.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()

        
    override func setupView() {
        configureViews()
        configureConstraints()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            checkCookie()
            print("web progress: \(web.estimatedProgress)")
            if web.estimatedProgress >= 0.9 {
                delegate?.done()
            }
        }
    }
    
    deinit {
        web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

// MARK: - Private Functions
extension WebView {
    private func configureViews() {
        [web].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [web.topAnchor.constraint(equalTo: topAnchor),
         web.leftAnchor.constraint(equalTo: leftAnchor),
         web.rightAnchor.constraint(equalTo: rightAnchor),
         web.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    private func checkCookie() {
        guard isSessionUpdated == false else { return }
        guard let data = eventInfoForm else { return }
        self.web.getCookies(completion: { dict in
            let session = UserDefaultsManager.getSession()
            guard !dict.isEmpty else {
                guard session == nil else { return }
                self.loadRequest(with: data)
                print("should return")
                return
            }
            
            guard let sessionDict = dict["session"] as? [String: Any],
                let newSession = sessionDict["Value"] as? String else {
                self.loadRequest(with: data)
                print("should return")
                return
            }
            print("entered")
            UserDefaultsManager.setSession(newSession)
            self.isSessionUpdated = true

            print("log cockie: \(dict)")
        })
    }
}

// MARK: - Actions
extension WebView {
    public func loadRequest(with data: [FormData: String]) {
        guard let urlRequest = RequestManager.shared.initialRequest(with: data) else {
            return
        }
        
        eventInfoForm = data
        
        web.load(urlRequest)
        delegate?.loading()
    }
        
    public func loadAppealRequest(with captcha: String) {
        guard let urlRequest = RequestManager.shared.finalRequest(with: captcha) else {
            return
        }

        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func sendImageToServer(image: UIImage, completion: @escaping (Result) -> ()) {
        guard let urlRequest = RequestManager.shared.uploadDataRequest(image: image) else {
            completion(.failure("Ссылка неверная, напишите в поддержку."))
            return
        }
        
        NetworkManager.shared.uploadImage(to: urlRequest) { result in
            completion(result)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            print(response.statusCode)
        }
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        web.evaluateJavaScript(Scripts.getCaptureImageURL, completionHandler: { resp, error in
            if let urlString = resp as? String, let url = URL(string: urlString) {
                self.delegate?.showCapture(with: url)
            }
        })
    }
}

// MARK: - Support
extension WebView {
    enum Scripts {
        static let submitForm = "$('.u-form__sbt').click();"
        static let setCheckbox = "$('.checkbox').click();"
        static let getCaptureImageURL = "document.querySelector('#request > div.b-form > div:nth-child(3) > div:nth-child(9) > div.img-captcha > div.bc-img > img').src"
        
    }
}

// MARK: - JQuery
// Script with website steps
// document.querySelector("body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > script:nth-child(1)")

// Removing elements
// "document.querySelector('.checkbox').remove();"  // worked!

// Submit button
// document.querySelector('.u-form__sbt')

// Shorted version
// $("body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > script:nth-child(1)")

extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
