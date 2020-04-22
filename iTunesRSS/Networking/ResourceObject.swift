//
//  ResourceObject.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct ResourceObject<A> where A: Decodable {
    let method: HTTPMethod<Data>
    let url: URL
    let parse: (Data) -> A? = { data in
        return try? JSONDecoder().decode(A.self, from: data)
    }
}

extension ResourceObject {
    init<T>(method: HTTPMethod<T>, url: URL) where T: Encodable {
        self.url = url
        self.method = method.map { json in
            try! JSONEncoder().encode(json)
        }
    }
}
