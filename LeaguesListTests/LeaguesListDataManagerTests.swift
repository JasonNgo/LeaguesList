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
        let league = League(fullName: "National Hockey League", slug: "nhl")
        let teamsDataManager = TeamsDataManager(league: league, fileAccessor: fileAccessor)
        let expected = teamsFactory.teams
        
        teamsDataManager.getTeams().done { teams in
            XCTAssert(expected == teams)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
    }
}
