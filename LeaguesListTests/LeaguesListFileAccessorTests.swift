//
//  LeaguesFileAccessorTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

// These tests will never fail because when constructing the URL in TheScoreEndPoint, a guard statement with
// a fatal error is used to ensure the URL is correctly built. In the case where we were accessing a REST API
// these tests would be valid to test for if the Router class was able to fetch data, check response codes etc,
// and send it back.
class LeaguesListFileAccessorTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    
    func testFetchLeaguesDataFromBundleURL() {
        fileAccessor.request(.leagues) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchNHLTeamsDataFromBundleURL() {
        let slug = "nhl"
        
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFetchNBATeamsDataFromBundleURL() {
        let slug = "nba"
        
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure:
                XCTFail()
            }
        }
    }
}
