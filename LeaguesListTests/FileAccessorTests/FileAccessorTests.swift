//
//  AccessorTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class FileAccessorTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    
    func testFetchLeaguesDataFromBundleURL() {
        let expectation = self.expectation(description: "Fetching Data")
        var expectedData: Data?
        
        fileAccessor.request(.leagues) { (result) in
            switch result {
            case .success(let data):
                expectedData = data
                expectation.fulfill()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedData)
    }
    
    func testFetchTeamsDataFromBundleURL() {
        let expectation = self.expectation(description: "Fetching Data")
        var expectedData: Data?
        let slug = "nhl"
        
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                expectedData = data
                expectation.fulfill()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedData)
    }
}
