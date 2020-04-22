//
//  URLRequest+init.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

extension URLRequest {
    init<A>(resource: ResourceObject<A>) {
        self.init(url: resource.url)
        httpMethod = resource.method.methodString
        if case let .post(data) = resource.method { httpBody = data }
    }
    
    init(imageResource: ImageResource) {
        self.init(url: imageResource.url)
        httpMethod = imageResource.method.methodString
    }
}
