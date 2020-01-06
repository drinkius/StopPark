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
    
    private func getCookieFromStore() {
        self.web.getCookies(completion: { dict in
            guard !dict.isEmpty else {
                self.initialRequest()
                print("should return")
                return
            }
            
            guard let sessionDict = dict["session"] as? [String: Any],
                let newSession = sessionDict["Value"] as? String else {
                self.initialRequest()
                print("should return")
                return
            }
            print("entered")
            UserDefaultsManager.setSession(newSession)

            print("log cockie: \(dict)")
        })
    }
}

// MARK: - Actions
extension WebView {
    public func initialRequest() {
        guard let urlRequest = RequestManager.shared.initialRequest() else {
            return
        }
        
        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func preFinalLoadData(_ data: [FormData: String]) {
        guard let urlRequest = RequestManager.shared.preFinalRequest(with: data) else {
            return
        }
        
        eventInfoForm = data
        
        web.load(urlRequest)
        delegate?.loading()
    }
        
    public func finalLoadData(with captcha: String) {
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
    
    public func getSubUnitCode(with code: String, completion: @escaping (Result) -> ()) {
        guard let urlRequest = RequestManager.shared.subUnitRequest(with: code) else {
            completion(.failure("Ссылка неверная, напишите в поддержку."))
            return
        }
        
        NetworkManager.shared.getSubUnitCode(from: urlRequest) { result in
            completion(result)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
        guard UserDefaultsManager.getSession() == nil else { return }
        
        guard let response = navigationResponse.response as? HTTPURLResponse else {
            getCookieFromStore()
            return
        }
            
        guard let headers = response.allHeaderFields as? [String: String], let url = response.url else {
            getCookieFromStore()
            return
        }
        
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                
        for cookie in cookies {
            if cookie.name == "session" {
                UserDefaultsManager.setSession(cookie.value)
            }
        }
        
        guard let _ = UserDefaultsManager.getSession() else {
            getCookieFromStore()
            return
        }
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

// Final response
// document.querySelector("body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div")

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
