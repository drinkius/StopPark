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
    func showFinalBody()
    
    func webView(_ webView: WebView, didReceiveCaptchaURL url: URL)
    func webView(_ webView: WebView, didReceiveError error: String)
}

class WebView: BaseView {
        
    public weak var delegate: WebViewDelegate?
    
    private var sessionGetItBlock: ((Result) -> ())?
    private var currentRequestType: RequestType = .initial
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
            self.sessionGetItBlock?(.success())
            UserDefaultsManager.setSession(newSession)

            print("log cockie: \(dict)")
        })
    }
    
    private func getCaptchaImage() {
        web.evaluateJavaScript(Scripts.getCaptureImageURL, completionHandler: { resp, error in
            guard let urlString = resp as? String, let url = URL(string: urlString) else {
                self.delegate?.webView(self, didReceiveError: Str.Generic.errorLoadCaptcha)
                return
            }
            self.delegate?.webView(self, didReceiveCaptchaURL: url)
        })
    }
    
    private func getFinalAppealData() {
        var newAppeal = Appeal(time: Date().timeIntervalSince1970)
        web.evaluateJavaScript(Scripts.getFinalID) { data, error in
            guard let text = data as? String else {
                self.getCaptchaImage()
                self.delegate?.webView(self, didReceiveError: Str.Generic.errorLoadData)
                return
            }
            
            newAppeal.id = text
            
            if !newAppeal.code.isEmpty {
                AppealManager.shared.saveNewAppeal(newAppeal)
                self.delegate?.showFinalBody()
            }
            
            if let error = error { self.delegate?.webView(self, didReceiveError: error.localizedDescription) }
        }
        web.evaluateJavaScript(Scripts.getFinalCode) { data, error in
            guard let text = data as? String else {
                self.getCaptchaImage()
                self.delegate?.webView(self, didReceiveError: Str.Generic.errorLoadData)
                return
            }
            
            newAppeal.code = text
            
            if !newAppeal.id.isEmpty {
                AppealManager.shared.saveNewAppeal(newAppeal)
                self.delegate?.showFinalBody()
            }
            
            if let error = error { self.delegate?.webView(self, didReceiveError: error.localizedDescription) }
        }
    }
}

// MARK: - Actions
extension WebView {
    public func initialRequest(completion: ((Result) -> ())? = nil) {
        guard let urlRequest = RequestManager.shared.initialRequest() else {
            return
        }
        sessionGetItBlock = completion
        currentRequestType = .initial
        
        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func preFinalLoadData() {
        guard let urlRequest = RequestManager.shared.preFinalRequest() else {
            return
        }

        currentRequestType = .preFinal

        web.load(urlRequest)
        delegate?.loading()
    }
        
    public func finalLoadData(with captcha: String) {
        guard let urlRequest = RequestManager.shared.finalRequest(with: captcha) else {
            return
        }
        currentRequestType = .final

        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func refreshCaptchaLoadData() {
        guard let urlRequest = RequestManager.shared.finalRequest(with: " ") else {
            return
        }
        
        currentRequestType = .preFinal
        
        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func sendImagesToServer(_ images: [UIImage], completion: @escaping (Result) -> ()) {
        var ids: [String] = []

        let group = DispatchGroup()
        var errorResult: Result?
        for image in images {
            group.enter()
            guard let urlRequest = RequestManager.shared.uploadDataRequest(image: image) else {
                errorResult = .failure(Str.Generic.errorWrongURL)
                group.leave()
                continue
            }
            guard errorResult == nil else {
                group.leave()
                continue
            }
            
            NetworkManager.shared.uploadImage(to: urlRequest) { result in
                switch result {
                case .failure(let text):
                    errorResult = .failure(text)
                    group.leave()
                case .success(let data):
                    guard let id = data as? String else { return }
                    ids.append(id)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            if let errorResult = errorResult {
                completion(errorResult)
            } else {
                UserDefaultsManager.setUploadImagesIds(ids)
                completion(.success())
            }
        }
    }
    
    public func getSubUnitCode(with code: String, completion: @escaping (Result) -> ()) {
        guard let urlRequest = RequestManager.shared.subUnitRequest(with: code) else {
            completion(.failure(Str.Generic.errorWrongURL))
            return
        }
        
        guard UserDefaultsManager.getSession() != nil else {
            initialRequest() { _ in
                NetworkManager.shared.getSubUnitCode(from: urlRequest) { result in
                    completion(result)
                }
            }
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
                sessionGetItBlock?(.success())
                UserDefaultsManager.setSession(cookie.value)
            }
        }
        
        guard let _ = UserDefaultsManager.getSession() else {
            getCookieFromStore()
            return
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch currentRequestType {
        case .preFinal: getCaptchaImage()
        case .final: getFinalAppealData()
        default: break
        }
    }
}

// MARK: - Support
extension WebView {
    enum Scripts {
        static let submitForm = "$('.u-form__sbt').click();"
        static let setCheckbox = "$('.checkbox').click();"
        static let getCaptureImageURL = "document.querySelector('#request > div.b-form > div:nth-child(3) > div:nth-child(9) > div.img-captcha > div.bc-img > img').src"
        static let getFinalBody = "document.querySelector('body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div').innerHTML"
        static let getFinalID = "document.querySelector('body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > p:nth-child(3) > b').innerHTML"
        static let getFinalCode = "document.querySelector('body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > p:nth-child(4) > b').innerHTML"
    }
    
    enum RequestType {
        case initial
        case preFinal
        case final
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

// Final ID path
// document.querySelector("body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > p:nth-child(3) > b")

// Final Code path
// document.querySelector("body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > p:nth-child(4) > b")
