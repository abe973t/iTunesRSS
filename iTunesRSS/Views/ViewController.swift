//
//  ViewController.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // TODO: use collectionView for genres
    // TODO: see how to get itunes btn to work
    
    var albums = [Results]()
    var cache = NSCache<NSString, UIImage>()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top 100 Albums"
        navigationController?.navigationBar.backgroundColor = .systemBlue
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "cell")
        addViews()
        
        fetchTop100Albums { (res) in
            DispatchQueue.main.async {
                if let fetchedAlbums = res.feed?.results {
                    self.albums = fetchedAlbums
                    self.tableView.reloadData()
                }
            }
        }
    }

    func addViews() {
        view.addSubview(tableView)
        
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchTop100Albums(completion: @escaping (iTunesResults) -> Void) {
        if let url = URL(string: Constants.rssEndpoint.rawValue) {
            URLSession.shared.dataTask(with: url) { (data, resposne, err) in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(iTunesResults.self, from: data)
                        completion(result)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlbumCell else {
            return UITableViewCell()
        }
        
        if let albumImgURL = albums[indexPath.row].artworkUrl100, let albumName = albums[indexPath.row].name, let artistName = albums[indexPath.row].artistName {
            cell.albumImg.downloadImageFrom(link: albumImgURL, contentMode: .scaleAspectFit, cache: cache)
            cell.albumLabel.text = albumName
            cell.artistLabel.text = artistName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dVC = DetailViewController()
        dVC.album = albums[indexPath.row]
        dVC.cache = cache
        navigationController?.pushViewController(dVC, animated: true)
    }
}
