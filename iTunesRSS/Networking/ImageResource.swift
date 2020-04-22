//
//  ImageResource.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

struct ImageResource {
    let url: URL
    let method: HTTPMethod<Data>
    let parse: (Data) -> UIImage?
}

extension ImageResource {
    init(imageUrl: URL) {
        self.url = imageUrl
        self.method = .get
        self.parse = { data in return UIImage(data: data) }
    }
}
