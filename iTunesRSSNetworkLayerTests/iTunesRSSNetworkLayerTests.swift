//
//  iTunesRSSNetworkLayerTests.swift
//  iTunesRSSNetworkLayerTests
//
//  Created by mcs on 4/20/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import iTunesRSS

class iTunesRSSNetworkLayerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkManagerGET() {
        let semaphore = DispatchSemaphore(value: 0)
        let nm = NetworkingManager.shared
        let url = URL(string: Constants.rssEndpoint.rawValue)!
        let invalidURL = URL(string: "itunes.com")!
        
        stub(condition: isHost("rss.itunes.apple.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!, headers: nil)
        }
        
        nm.loadData(url: url) { (data, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else {
                // test that the stubbing actually works
                let response = String(decoding: data!, as: UTF8.self)
                XCTAssertTrue(response.contains("MOCK DATA"))
            }
            
            semaphore.signal()
        }
        
        nm.loadData(url: invalidURL) { (data, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        
        if semaphore.wait(timeout: DispatchTime.now() + .seconds(3)) == .timedOut {
            XCTFail("timed out")
        }
    }
    
    func testNetworkManagerPOST() {
        let semaphore = DispatchSemaphore(value: 0)
        let nm = NetworkingManager.shared
        let url = URL(string: Constants.rssEndpoint.rawValue)!
        let invalidURL = URL(string: "itunes.com")!
        
        stub(condition: isHost("rss.itunes.apple.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!, headers: nil)
        }
        
        nm.postData(url: url, headers: [:], data: nil) { (data, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            semaphore.signal()
        }
        
        nm.postData(url: invalidURL, headers: [:], data: nil) { (data, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        
        if semaphore.wait(timeout: DispatchTime.now() + .seconds(3)) == .timedOut {
            XCTFail("timed out")
        }
    }
    
    func testNetworkManagerLoadObject() {
        let nm = NetworkingManager.shared
        let url = URL(string: Constants.rssEndpoint.rawValue)!
        
        stub(condition: isHost("rss.itunes.apple.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!, headers: nil)
        }
        
        let resource = ResourceObject<iTunesResults>(method: .get, url: url)
        nm.loadObject(resource: resource) { (object, request, err) in
            if let error = err {
                XCTFail(error.localizedDescription)
            } else {
                XCTAssertNotNil(object)
                XCTAssertTrue(object!.feed!.results!.count > 1)
            }
        }
    }
    
    func testNetworkManagerLoadImage() {
        let nm = NetworkingManager.shared
        let url = URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music113/v4/93/a3/84/93a3841d-63f3-bc8c-9e4c-bc714c090ca8/20UMGIM22468.rgb.jpg/200x200bb.png")!
        
        stub(condition: isHost("is5-ssl.mzstatic.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "nt3", ofType: "png")!, headers: nil)
        }
        
        let resource = ImageResource(imageUrl: url)
        nm.loadImage(resource: resource) { (image) in
            XCTAssertNotNil(image)
            XCTAssertTrue(image! is UIImage)
        }
    }
}
