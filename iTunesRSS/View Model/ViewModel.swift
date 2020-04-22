//
//  ViewModel.swift
//  iTunesRSS
//
//  Created by mcs on 4/14/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

protocol ViewModelProtocol {
    var albums: [Results]? { get set }
    var cache: NSCache<NSString, UIImage> { get }
    func fetchTop100Albums()
    func fetchAlbum(index: Int) -> Results?
    func createDetailViewController(albumIndex: Int) -> DetailViewController
}

class ViewModel: ViewModelProtocol {
    
    var cache = NSCache<NSString, UIImage>()
    var albums: [Results]?
    var albumCount: Int {
        albums?.count ?? 0
    }
    
    init() {
        fetchTop100Albums()
    }
    
    func fetchTop100Albums() {
        if let url = URL(string: Constants.rssEndpoint.rawValue) {
            let resource = ResourceObject<iTunesResults>(method: .get, url: url)
            
            NetworkingManager.shared.loadObject(resource: resource) { (result, request, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else if let parsedResult = result, let fetchedAlbums = parsedResult.feed?.results {
                    self.albums = fetchedAlbums
                    NotificationCenter.default.post(name: .reload, object: nil)
                }
            }
        }
    }
    
    func fetchAlbum(index: Int) -> Results? {
        return albums?[index] ?? nil
    }
    
    func createDetailViewController(albumIndex: Int) -> DetailViewController {
        let dvc = DetailViewController()
        dvc.album = fetchAlbum(index: albumIndex)
        dvc.viewModel = self
        return dvc
    }
}
