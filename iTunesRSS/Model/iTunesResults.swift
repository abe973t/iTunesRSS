//
//  iTunesResults.swift
//  iTunesRSS
//
//  Created by mcs on 4/9/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct iTunesResults: Codable {
    let feed: Feed?
}

struct Feed: Codable {
    let results: [Results]?
}

struct Results: Codable {
    let artistName: String?
    let releaseDate: String?
    let name: String?
    let copyright: String?
    let artworkUrl100: String?
    let genres: [Genres]?
    let url: String?
}

struct Genres: Codable {
    let name: String?
}
