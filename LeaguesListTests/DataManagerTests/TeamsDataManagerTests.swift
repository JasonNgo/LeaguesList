//
//  TeamsDataManagerTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-02-07.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class TeamsDataManagerTests: XCTestCase {
    let fileAccessor = FileAccessor<SportsEndPoint>()
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
