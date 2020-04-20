//
//  iTunesRSSTests.swift
//  iTunesRSSTests
//
//  Created by mcs on 4/14/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import iTunesRSS

class MockViewModel: ViewModelProtocol {
    
    var albums: [Results]?
    var cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    init() {
        fetchTop100Albums()
    }
    
    func fetchTop100Albums() {
        albums = [
            Results(artistName: "Lil Uzi Vert", releaseDate: "04-01-2017", name: "Luv Is Rage 2", copyright: "Atlantic", artworkUrl100: nil, genres: nil, url: nil),
            Results(artistName: "The Weeknd", releaseDate: "04-01-2020", name: "After Hours", copyright: "XOTWOD", artworkUrl100: nil, genres: nil, url: nil)
        ]
    }
    
    // TODO: test this bit too
    func fetchAlbum(index: Int) -> Results? {
        return albums![index]
    }
    
    func createDetailViewController(albumIndex: Int) -> DetailViewController {
        let dVC = DetailViewController()
        dVC.album = albums![albumIndex]
        dVC.viewModel = self
        return dVC
    }
}

class iTunesRSSTests: XCTestCase {
    
    let viewModel = MockViewModel()
    let mainViewController = MainViewController()
    var detailViewController: DetailViewController?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAlbumsCreated() {
        XCTAssertNotNil(viewModel.albums)
        XCTAssertEqual(viewModel.albums?.count, 2)
    }
    
    func testCreateDetailVC() {
        let mockDetailVC = viewModel.createDetailViewController(albumIndex: 0)
        
        XCTAssertTrue(mockDetailVC is DetailViewController)
    }
    
    func testDecoding() throws {
        let jsonPath = try XCTUnwrap(Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json"))
        let jsonPathURL = URL(fileURLWithPath: jsonPath)
        let jsonData = try Data(contentsOf: jsonPathURL)
        
        XCTAssertNoThrow(try JSONDecoder().decode(iTunesResults.self, from: jsonData))
    }
}
