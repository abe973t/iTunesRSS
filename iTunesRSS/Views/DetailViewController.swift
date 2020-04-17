//
//  DetailViewController.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var album: Results!
    var viewModel: ViewModelProtocol!
    
    let albumImg: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.backgroundColor = .white
        return lbl
    }()
    
    let albumLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.backgroundColor = .white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let releaseDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let copyrightLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let genreLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let iTunesBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("View in iTunes", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        addViews()
        setupView()
    }
    
    @objc func openLink() {
        if let urlString = album.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    fileprivate func setupView() {
        albumImg.downloadImageFrom(link: album.artworkUrl100 ?? "", contentMode: .scaleAspectFit, cache: viewModel.cache)
        artistLabel.text = album.artistName ?? "Artist N/A"
        albumLabel.text = album.name ?? "Title N/A"
        releaseDateLabel.text = "Release Date: \(album.releaseDate ?? "N/A")"
        copyrightLabel.text = "Copyright: \(album.copyright ?? "n/a")"
        
        if let genres = album.genres {
            var text = "Genres: "
            
            for genre in genres {
                text += "\(genre.name ?? "N/A")  "
            }
            
            genreLabel.text = text
        }
    }
    
    func addViews() {
        view.addSubview(albumImg)
        view.addSubview(albumLabel)
        view.addSubview(artistLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(copyrightLabel)
        view.addSubview(genreLabel)
        view.addSubview(iTunesBtn)
        
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            albumImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            albumImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumImg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumImg.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            albumLabel.topAnchor.constraint(equalTo: albumImg.bottomAnchor),
            albumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            albumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            albumLabel.heightAnchor.constraint(equalToConstant: 50),
            
            artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            artistLabel.heightAnchor.constraint(equalToConstant: 30),
            
            releaseDateLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20),
            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 40),
            
            copyrightLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            copyrightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            copyrightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 10),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: iTunesBtn.topAnchor, constant: -10),
            
            iTunesBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            iTunesBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iTunesBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iTunesBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
