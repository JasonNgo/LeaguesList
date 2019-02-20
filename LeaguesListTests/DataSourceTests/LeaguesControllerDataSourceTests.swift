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
    let fileAccessor = FileAccessor<SportsEndPoint>()
    lazy var leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
    lazy var dataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)

    func testFetchingLeagues() {
        var unexpectedError: NSError?
        let expectation = self.expectation(description: "Fetching Leagues")
        
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
        fetchLeagues()
        
        let expectedLeague = League(fullName: "CFL Football", slug: "cfl")
        let actualLeague = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualLeague! == expectedLeague)
    }
    
    func testNoSearchResults() {
        fetchLeagues()
        
        dataSource.filterResultsBy("helloworldomgfoobar")
        
        let expectedLeague: League? = nil
        let actualLeague = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(expectedLeague == actualLeague)
    }
    
    func testSearchFilter() {
        fetchLeagues()
        
        let searchText = "w"
        dataSource.filterResultsBy(searchText)
        
        let expectedLeague = League(fullName: "NCAA Women's Basketball", slug: "wcbk")
        let actualLeague = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualLeague == expectedLeague)
    }
    
    private func fetchLeagues() {
        let expectation = self.expectation(description: "Fetching Leagues")
        
        dataSource.fetchLeagues { error in
            if let _ = error { return }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
