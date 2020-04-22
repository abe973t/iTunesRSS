//
//  NetworkManagerViewController.swift
//  NetworkManager
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    func postData(url: URL, headers: [String: String], data: Data?, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }.resume()
    }
    
    func loadData(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }.resume()
    }
    
    func loadObject<A>(resource: ResourceObject<A>, completion: @escaping (A?, URLRequest?, Error?) -> ()) {
        let request = URLRequest(resource: resource)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, request, error)
                return
            }
            
            completion(data.flatMap(resource.parse), request, nil)
        }.resume()
    }
    
    func loadImage(resource: ImageResource, completion: @escaping (UIImage?) -> ()) {
        let request = URLRequest(imageResource: resource)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                completion(nil)
                return
            }
            
            completion(data.flatMap(resource.parse))
        }.resume()
    }
}
