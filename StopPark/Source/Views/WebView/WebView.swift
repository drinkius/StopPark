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
}

class WebView: BaseView {
        
    public weak var delegate: WebViewDelegate?
    
    private var step: Int = 0
    
    private let url = URL(string: "https://xn--90adear.xn--p1ai/request_main")
    private let config = WKWebViewConfiguration()
    private lazy var web: WKWebView = {
        let w = WKWebView(frame: .zero, configuration: config)
        w.navigationDelegate = self
        w.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()

        
    override func setupView() {
        loadRequest()
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
}

// MARK: - Actions
extension WebView {
    public func loadRequest() {
        guard let url = url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let dataBody = RequestManager.shared.createFormURLEncodedBody(regionCode: 01, subUnit: 1, message: "Обращение")
        urlRequest.httpBody = dataBody
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        if let session = UserDefaultsManager.getUploadImagesSession() {
//            urlRequest.addValue("regionCode=77; session=\(session)", forHTTPHeaderField: "cookie")
//        }
        web.load(urlRequest)
        delegate?.loading()
    }
    
    public func loadFinalRequest() {
        guard let url = url else { return }
        var urlRequest = URLRequest(url: url)
        
        let boundary = RequestManager.shared.generateBoundaryString()
        let photo = Media(withImage: phot, forKey: "file", mime: "application/octet-stream", filename: "")!
        let dataBody = RequestManager.shared.finalRequest(regionCode: 01, subUnit: 1, message: "Обращение", media: [photo], boundary: boundary)

        
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = dataBody
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9", forHTTPHeaderField: "accept")
//        urlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "x-requested-with")
        urlRequest.setValue("https://xn--90adear.xn--p1ai/request_main/", forHTTPHeaderField: "Referer")

        web.load(urlRequest)
        delegate?.loading()
    }
    
    private func openForm() {
        web.evaluateJavaScript(Scripts.setCheckbox)
        web.evaluateJavaScript(Scripts.submitForm)
        delegate?.loading()
    }
    
    private func fillForm() {
        web.evaluateJavaScript("document.querySelector('#request > div.b-form > div:nth-child(1) > div.bf-item-holder > table > tbody > tr:nth-child(3) > td:nth-child(2) > input').value = 'Hello Result';")
        print("form filled")
        
        web.evaluateJavaScript("document.querySelector('#request > div.b-form > div:nth-child(1) > div.bf-item-holder > table > tbody > tr:nth-child(1) > td:nth-child(2) > span > span.selection > span').value = '23 Краснодарский край';")
    }
}


extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            print(response.statusCode)
        }
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        web.evaluateJavaScript("document.querySelector('body > div.ln-page > div > div.ln-content.wrapper.clearfix > div:nth-child(4) > div > script:nth-child(1)').innerHTML", completionHandler: { responce, error in
//            if let resp = responce as? String {
//                print(resp)
//                let range = NSRange(location: 0, length: resp.utf16.count)
//                let regex = try! NSRegularExpression(pattern: "[^step.+](\\d)")
//                let result = regex.firstMatch(in: resp, options: [], range: range)
//                if let nsrange = result?.range(at: 1) {
//                    let range = Range(nsrange, in: resp)
//
//                    print("result \(resp[range!])")
//                    self.step = Int(String(resp[range!]))!
//                }
//            }
//            switch self.step {
//            case 0, 1: self.openForm()
//            case 2: self.fillForm()
//            default: break
//            }
//        })
        web.evaluateJavaScript(Scripts.getCaptureImageURL, completionHandler: { resp, error in
            if let urlString = resp as? String, let url = URL(string: urlString) {
                self.delegate?.showCapture(with: url)
            }
            
        })
    }
}

extension WebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        guard let dict = message.body as? [String: Any] else { return }
        print(message.body)
    }
}

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
