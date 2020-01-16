//
//  UIImage+download.swift
//  StopPark
//
//  Created by Arman Turalin on 12/17/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadCapture(with url: URL, completion: ((Result) -> ())?) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(.requestMainRefer)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print(data)
                completion?(.success())
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        print(image)
                        self.image = image
                    }
                }
            } else if let error = error {
                completion?(.failure(error.localizedDescription))
            } else {
                completion?(.failure("Неизвестная ошибка."))
            }
        }.resume()
    }
}
