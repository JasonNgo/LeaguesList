//
//  LeaguesListDataManagerTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesDataManagerTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    let leagueFactory = LeaguesFactory()
    
    func testLeaguesDataManagerDataFetching() {
        let leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        let expected = leagueFactory.leagues
        
        leaguesDataManager.fetchListOfLeagues { result in
            switch result {
            case .success(let leagues):
                XCTAssert(leagues == expected)
            case .failure:
                XCTFail()
            }
        }
    }
}

class TeamsDataManagerTests: XCTestCase {
    let fileAccessor = FileAccessor<TheScoreEndPoint>()
    let teamsFactory = TeamsFactory()
    
    func testTeamsDataManagerNHLDataTransformation() {
        let teamsDataManager = TeamsDataManager(fileAccessor: fileAccessor)
        let slug = "nhl"
        let expected = teamsFactory.teams
        
        teamsDataManager.getTeamsForSlug(slug) { result in
            switch result {
            case .success(let teams):
                XCTAssert(expected == teams)
            case .failure:
                XCTFail()
            }
        }
    }
}
