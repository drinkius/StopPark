//
//  NetworkManager.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

enum Result {
    case failure(String)
    case success(Any? = nil)
}

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}
        
    func uploadImage(to url: URLRequest, completion: @escaping (Result) -> Void) {
        request(with: url) { data, error in
            guard let data = data else {
                let description = error?.localizedDescription ?? Str.Generic.noConnection
                completion(.failure(description))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(.failure(Str.Generic.errorLoadData))
                return
            }
            guard let file = json["file"] as? [String: Any], let id = file["id"] as? String else {
                completion(.failure(Str.Generic.errorLoadData))
                return
            }
            
            print(json)
            completion(.success(id))
        }
    }
    
    func getSubUnitCode(from url: URLRequest, completion: @escaping (Result) -> ()) {
        request(with: url) { data, error in
            guard let data = data else {
                let description = error?.localizedDescription ?? Str.Generic.noConnection
                completion(.failure(description))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                completion(.failure(Str.Generic.errorLoadData))
                return
            }
            
            guard let code = json.keys.first else {
                completion(.failure(Str.Generic.errorLoadData))
                return
            }
            
            completion(.success(code))
            
            print(json)
        }
    }

    func request(with url: URLRequest, completion: @escaping (Result) -> ()) {
        request(with: url) { data, error in
            guard let data = data else {
                let description = error?.localizedDescription ?? Str.Generic.noConnection
                completion(.failure(description))
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(.failure(Str.Generic.errorLoadData))
                print(String(data: data, encoding: .utf8) ?? "No string")
                return
            }

            completion(.success(json))

            print(json)
        }
    }
    
    private func request(with url: URLRequest, completion: @escaping (Data?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            completion(data, nil)
        }.resume()
    }
}
