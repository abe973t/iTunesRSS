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
        let nm = NetworkManager.shared
        let url = URL(string: Constants.rssEndpoint.rawValue)!
        let invalidURL = URL(string: "itunes.com")!
        
        stub(condition: isHost("rss.itunes.apple.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!, headers: nil)
        }
        
        nm.get(url: url) { (data, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else {
                // test that the stubbing actually works
                let response = String(decoding: data!, as: UTF8.self)
                XCTAssertTrue(response.contains("MOCK DATA"))
            }
            
            semaphore.signal()
        }
        
        nm.get(url: invalidURL) { (data, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        
        if semaphore.wait(timeout: DispatchTime.now() + .seconds(3)) == .timedOut {
            XCTFail("timed out")
        }
    }
    
    func testNetworkManagerPOST() {
        let semaphore = DispatchSemaphore(value: 0)
        let nm = NetworkManager.shared
        let url = URL(string: Constants.rssEndpoint.rawValue)!
        let invalidURL = URL(string: "itunes.com")!
        
        stub(condition: isHost("rss.itunes.apple.com")) { _ in
            return fixture(filePath: Bundle.main.path(forResource: "iTunesResultJSON", ofType: "json")!, headers: nil)
        }
        
        nm.post(url: url, headers: [:], data: nil) { (data, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            semaphore.signal()
        }
        
        nm.post(url: invalidURL, headers: [:], data: nil) { (data, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        
        if semaphore.wait(timeout: DispatchTime.now() + .seconds(3)) == .timedOut {
            XCTFail("timed out")
        }
    }
}
