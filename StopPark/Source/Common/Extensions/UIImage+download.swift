//
//  UIImage+download.swift
//  StopPark
//
//  Created by Arman Turalin on 12/17/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadCapture(with url: URL) {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        addSubview(indicator)
        indicator.startAnimating()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Referer": "https://xn--90adear.xn--p1ai/request_main/"]
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        print(image)
                        self.image = image
                    }
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let resp = response as? HTTPURLResponse {
                print(resp.statusCode)
            }
            
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        }.resume()
    }
}
