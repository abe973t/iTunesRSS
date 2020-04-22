//
//  HTTPMethod.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

enum HTTPMethod<Body> {
    case get
    case post(Body)
}

extension HTTPMethod {
    var methodString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HTTPMethod<B> where B: Encodable {
        switch self {
        case .get:
            return .get
        case .post(let body):
            return .post(f(body))
        }
    }
}
