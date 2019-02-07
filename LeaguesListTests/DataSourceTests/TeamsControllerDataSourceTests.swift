//
//  TeamsControllerDataSourceTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-02-07.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class TeamsControllerDataSourceTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    lazy var teamsDataManager = TeamsDataManager(league: league!, fileAccessor: fileAccessor)
    lazy var dataSource = TeamsControllerDataSource(teamsDataManager: teamsDataManager)
    
    var league: League?
    
    func testFetchingTeams() {
        self.league = League(fullName: "NHL Hockey", slug: "nhl")
        
        var unexpectedError: NSError?
        let expectation = self.expectation(description: "Fetching Teams")
        
        dataSource.fetchTeams { error in
            if let error = error {
                unexpectedError = error as NSError
            }
            
            DispatchQueue.main.async { expectation.fulfill() }
        }
    
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(unexpectedError)
    }
    
    func testFetchingFirstLeague() {
        self.league = League(fullName: "NHL Hockey", slug: "nhl")
        fetchTeams()
        
        let expectedTeam = Team(fullName: "Anaheim Ducks", name: "Ducks", location: "Anaheim", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/21/logo.png", colour1Hex: "F57D31", colour2Hex: "B6985A")
        let actualTeam = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualTeam! == expectedTeam)
    }
    
    func testNoSearchResults() {
        self.league = League(fullName: "NHL Hockey", slug: "nhl")
        fetchTeams()
        dataSource.filterResultsBy("helloworldomgfoobar")
        
        let expectedTeam: Team? = nil
        let actualTeam = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualTeam == expectedTeam)
    }
    
    func testSearchFilter() {
        self.league = League(fullName: "NHL Hockey", slug: "nhl")
        fetchTeams()

        let searchText = "n"
        dataSource.filterResultsBy(searchText)

        let expectedTeam = Team(fullName: "Anaheim Ducks", name: "Ducks", location: "Anaheim", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/21/logo.png", colour1Hex: "F57D31", colour2Hex: "B6985A")
        let actualTeam = dataSource.item(at: IndexPath(item: 0, section: 0))
        XCTAssert(actualTeam == expectedTeam)
    }
    
    private func fetchTeams() {
        let expectation = self.expectation(description: "Fetching Teams")
        dataSource.fetchTeams { error in
            if let _ = error { return }
            DispatchQueue.main.async { expectation.fulfill() }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

