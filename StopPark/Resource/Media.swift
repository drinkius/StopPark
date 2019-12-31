//
//  Media.swift
//  StopPark
//
//  Created by Arman Turalin on 12/21/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, mime: String = "image/jpeg", filename: String = "photo\(arc4random()).jpeg") {
        self.key = key
        self.mimeType = mime
        self.filename = filename
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

