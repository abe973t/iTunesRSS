//
//  UIImageView+downloadImage.swift
//  CollectionViewProgrammatically
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode, cache: NSCache<NSString, UIImage>) {
        if let cachedImg = cache.object(forKey: link as NSString) {
            self.image = cachedImg
        } else if let url = URL(string: link) {
            let imgResource = ImageResource(imageUrl: url)
            
            NetworkingManager.shared.loadImage(resource: imgResource) { (imgResult) in
                if let img = imgResult {
                    DispatchQueue.main.async {
                        self.contentMode = contentMode
                        self.image = img
                        cache.setObject(img, forKey: link as NSString)
                    }
                }
            }
        }
    }
}
