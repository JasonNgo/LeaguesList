//
//  LeaguesControllerDataSourceTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-02-07.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesControllerDataSourceTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    lazy var leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
    lazy var dataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)

    func testFetchingLeagues() {
        let expectation = self.expectation(description: "Fetching Leagues")
        var unexpectedError: NSError?
        
        dataSource.fetchLeagues { error in
            if let error = error {
                unexpectedError = error as NSError
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(unexpectedError)
    }
    
    func testFetchingFirstLeague() {
        let expectation = self.expectation(description: "Fetching Leagues")
        var unexpectedError: NSError?
        let expectedLeague = League(fullName: "CFL Football", slug: "cfl")
        
        dataSource.fetchLeagues { error in
            if let error = error {
                unexpectedError = error as NSError
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let actualLeague = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualLeague == expectedLeague)
        XCTAssertNil(unexpectedError)
    }
}
